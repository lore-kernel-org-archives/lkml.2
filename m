Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966456Ab2EOTCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:02:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36872 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966425Ab2EOTCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:02:30 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RESEND PATCH 0/2] arch/CPU hotplug: Add missing CPU Hotplug bits to
 fix nasty issues
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mpatocka@redhat.com, stepanm@codeaurora.org, tglx@linutronix.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-am33-list@redhat.com
Date: Wed, 16 May 2012 00:31:43 +0530
Message-ID: <20120515190115.22459.93544.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051508-0260-0000-0000-00000120779E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, some of the CPU Hotplug code has been duplicated in all of
the architectures. And in some cases, very poorly (some architectures left
out some of the important bits), to add to the woes.

Commit 5fbd036b552f633abb394a319f7c62a5c86a9cd7 (sched: Cleanup cpu_active
madness) introduced some changes that made the scheduler rely on the
CPU_STARTING notifier. And hence those architectures which forgot to
send out the CPU_STARTING notification will almost surely get into trouble.
(Xen is one example[1]).

The proper fix would be to pull out these bits into generic CPU Hotplug code.
But for now, fix this regression by adding the missing bits in the respective
architectures.

[1].https://lkml.org/lkml/2012/3/20/459
--
 Srivatsa S. Bhat (2):
      parisc/CPU hotplug: Add missing call to notify_cpu_starting()
      mn10300/CPU hotplug: Add missing call to notify_cpu_starting()


  arch/mn10300/kernel/smp.c |    9 ++++++---
 arch/parisc/kernel/smp.c  |    8 +++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

