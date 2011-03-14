Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1CNPaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:30:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1CNP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:48 -0400
Message-Id: <20110314150613.749843433@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 14 Mar 2011 16:06:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [RFC][PATCH 00/14] Rewrite sched_domain/sched_group creation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I got annoyed with the whole sched_domain/sched_group creation mess again
and decided to actuall do something about it. See here ;-)

Its not completely done yet, but much of the ground-work is there.

The final goal is to be able to have a simple way to dynamically specify the
architecture topoplogy and have the generic code in charge of building the data
structures. The architecture would need to provide a function that maps a cpu
to a cpumask and a function that initializes the sched_domain (flags etc.),
this would replace the now still hard-coded __build_*_sched_domain() calls in
__build_sched_domains().

With that we can also kill the current NODE and ALLNODES mess and generate
appropriate masks from say the ACPI SLIT table by grouping CPUs on their node
distance.

This would allow us to kill the horrid mess in x86's cpu_coregroup_mask() and
properly support the AMD magnycours stuff.

Anyway, not quite there yet.. patches build and boot on a 2*6*2 wsm box.

---
 include/linux/sched.h |   19 +-
 kernel/sched.c        |  817 +++++++++++++------------------------------------
 kernel/sched_fair.c   |   32 ++-
 3 files changed, 258 insertions(+), 610 deletions(-)


