Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2FNHsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab2FNHsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:48:21 -0400
Date: Thu, 14 Jun 2012 09:48:15 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Bug, warning and stylistic fixes to cpu_mask_to_apicid() ops
Message-ID: <20120614074814.GC3383@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set completes a cleanup of cpu_mask_to_apicid() operations
and fixes few bugs, warnings and code uglinesses.

patch 2 - acked by Suresh Siddha and Yinghai Lu
patch 3 - addresses comments of Ingo Molnar on patch 2

Attached patches:
  1/6 x86/x2apic/cluster: vector_allocation_domain() should return a value
  2/6 x86/apic: Eliminate cpu_mask_to_apicid() operation
  3/6 x86/apic: Fix ugly casting and branching in cpu_mask_to_apicid_and()
  4/6 x86/apic/es7000+summit: Fix compile warning in cpu_mask_to_apicid()
  5/6 x86/apic/es7000+summit: Always make valid apicid from a cpumask
  6/6 x86/apic/es7000: Make apicid of a cluster (not CPU) from a cpumask

 arch/x86/include/asm/apic.h           |   33 ++++++++-------------------------
 arch/x86/kernel/apic/apic.c           |   26 +++++++-------------------
 arch/x86/kernel/apic/apic_flat_64.c   |    2 --
 arch/x86/kernel/apic/apic_noop.c      |    1 -
 arch/x86/kernel/apic/apic_numachip.c  |    1 -
 arch/x86/kernel/apic/bigsmp_32.c      |    1 -
 arch/x86/kernel/apic/es7000_32.c      |   12 ++++++------
 arch/x86/kernel/apic/io_apic.c        |    3 ++-
 arch/x86/kernel/apic/numaq_32.c       |    8 --------
 arch/x86/kernel/apic/probe_32.c       |    1 -
 arch/x86/kernel/apic/summit_32.c      |    9 +++++----
 arch/x86/kernel/apic/x2apic_cluster.c |   20 ++------------------
 arch/x86/kernel/apic/x2apic_phys.c    |    1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |   31 +++++++------------------------
 arch/x86/platform/uv/uv_irq.c         |    2 +-
 15 files changed, 38 insertions(+), 113 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
