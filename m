Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1LLAcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:32:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52471 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1LLAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:32:44 -0500
MIME-Version: 1.0
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date: Mon, 12 Dec 2011 03:32:23 +0300
Message-ID: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
Subject: [Regression, bisected] a3e06bbe8445f57eb949e6474c5a9b30f24d2057: KVM:
 emulate lapic tsc deadline timer for guest"
To: Kernel development list <linux-kernel@vger.kernel.org>
Cc: Liu Jinsong <jinsong.liu@intel.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

After a recent change, qemu --enable-kvm (both 0.15.92 and 1.0) fails
to boot illumos. The OS gets stuck pretty late in the boot process,
without any hints from the guest. MDB (the illumos kenrnel debugger)
failed to clarify the situation at once, the kernel seems to be stuck
idling. I've bisected the problem to commit
a3e06bbe8445f57eb949e6474c5a9b30f24d2057. Please let me know if you
need me to collect any debug information or test any patches.
