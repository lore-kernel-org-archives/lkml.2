Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0IGLle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:41:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64336 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0IGLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KeEsnnOnXSMp1I2PAc+lbx/8OFrI2MiClrn46C4H0dUfHp9Y8FSc3C3KMxWcW7p9Sa
         Y7jTbo+go6XwGO/QU4YK/6oblsnNr4LYe+ro2NGAl18uUsOM4pywu9Fz8rargzGtJ5Gl
         RuqaMCUgSFxnDtk4LrbRUO2Cr8TCkXk+3mbMo=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: PATCH [0/2] percpu: Local cpu pointer optimizations
Date: Tue,  7 Sep 2010 07:41:08 -0400
Message-Id: <1283859670-6687-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set allows arches to provide an optimized way of shifting
a per-cpu pointer for the current cpu.

On an x86-32 defconfig build, these patches save 1304 bytes of text.

  text    data     bss     dec     hex filename
7298335  717480 1374104 9389919  8f475f vmlinux.orig
7297283  717480 1374104 9388867  8f4343 vmlinux.1
7297031  717480 1374104 9388615  8f4247 vmlinux.2

[PATCH 1/2] x86, percpu: Optimize this_cpu_ptr
[PATCH 2/2] percpu: Optimize __get_cpu_var()

 arch/x86/include/asm/percpu.h |   11 +++++++++++
 include/asm-generic/percpu.h  |   14 +++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

v2: Added comments
