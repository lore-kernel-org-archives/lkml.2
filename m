Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0IDRWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:22:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37676 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0IDRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ezfmDkgrEuEDx1zCGyEvr9oIAOwvCqz5fIyAShAiI9lvjMcpGGj5dp4q0AUcXuVprd
         smz2Ko2Q3sA96jMkau7DMHAjTiMeZe/1ujvuDfRUaxa1O9FNq4/Yx8Q5KxWFpP11Sk5R
         hj2VIhKe4JfmvSDQcvcYI23XLrCNf58VH1kV4=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: PATCH [0/2] percpu: Local cpu pointer optimizations
Date: Sat,  4 Sep 2010 13:21:09 -0400
Message-Id: <1283620871-818-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set allows arches to provide an optimized way of shifting
a per-cpu pointer for the current cpu.  

On an x86-32 defconfig build, these patches save 1304 bytes of text.

   text	   data	    bss	    dec	    hex	filename
7298335	 717480	1374104	9389919	 8f475f	vmlinux.orig
7297283	 717480	1374104	9388867	 8f4343	vmlinux.1
7297031	 717480	1374104	9388615	 8f4247	vmlinux.2

[PATCH 1/2] x86, percpu: Optimize this_cpu_ptr
[PATCH 2/2] percpu: Optimize __get_cpu_var()

 arch/x86/include/asm/percpu.h |    9 +++++++++
 include/asm-generic/percpu.h  |   14 +++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)
