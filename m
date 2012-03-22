Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2CVLdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:33:06 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58259 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2CVLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:33:03 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/4] arch/CPU hotplug: Add missing CPU Hotplug bits to fix
 nasty issues
To: rkuo@codeaurora.org, tglx@linutronix.de, linas@codeaurora.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, dhowells@redhat.com,
        yasutake.koichi@jp.panasonic.com, akpm@linux-foundation.org,
        benh@kernel.crashing.org, jesper.nilsson@axis.com, cmetcalf@tilera.com,
        linux@arm.linux.org.uk, jejb@parisc-linux.org, deller@gmx.de,
        vapier@gentoo.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org
Date: Thu, 22 Mar 2012 16:58:00 +0530
Message-ID: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12032211-2000-0000-0000-000006E04BA0
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
 Srivatsa S. Bhat (4):
      hexagon/CPU hotplug: Add missing call to notify_cpu_starting()
      mn10300/CPU hotplug: Add missing call to notify_cpu_starting()
      parisc/CPU hotplug: Add missing call to notify_cpu_starting()
      tile/CPU hotplug: Add missing call to notify_cpu_starting()


  arch/hexagon/kernel/smp.c  |    5 +++++
 arch/mn10300/kernel/smp.c  |    8 ++++++--
 arch/parisc/kernel/smp.c   |    7 ++++++-
 arch/tile/kernel/smpboot.c |    2 ++
 4 files changed, 19 insertions(+), 3 deletions(-)


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

