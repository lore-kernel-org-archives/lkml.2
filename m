Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab2FELXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab2FELXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:23:06 -0400
Date: Tue, 5 Jun 2012 13:22:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/8] x86: apic: Cleanup and improve four apic operations
Message-ID: <20120605112255.GA11434@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is an attempt to make some implementations of four apic
operations bit more sane and readable. It was booted with these apic drivers:
flat/flat, flat/phys, bigsmp, x2apic/cluster.

- patches 2,3,4	get rid of duplicate implementation of apic operations
- patch 5	tunes the way vectors are assigned
- patch 6	makes minor improvement to the code
- patches 7,8	are a continuation of 18374d8 commit

Attached patches:
  1/8 x86: apic: Trivial whitespace fixes
  2/8 x86: apic: Factor out default target_cpus() operation
  3/8 x86: apic: Factor out default cpu_mask_to_apicid() operations
  4/8 x86: apic: Factor out default vector_allocation_domain() operations
  5/8 x86: apic: Try to spread IRQ vectors to different priority levels
  6/8 x86: apic: Avoid useless scanning thru a cpumask in
    assign_irq_vector()
  7/8 x86: apic: Make cpu_mask_to_apicid() operations return error code
  8/8 x86: apic: Make cpu_mask_to_apicid() operations check cpu_online_mask

 arch/x86/include/asm/apic.h           |   75 +++++++++++++++++---
 arch/x86/include/asm/x2apic.h         |   18 -----
 arch/x86/kernel/apic/apic.c           |   31 ++++++++
 arch/x86/kernel/apic/apic_flat_64.c   |   78 ++------------------
 arch/x86/kernel/apic/apic_noop.c      |   10 ++--
 arch/x86/kernel/apic/apic_numachip.c  |   51 +------------
 arch/x86/kernel/apic/bigsmp_32.c      |   49 +------------
 arch/x86/kernel/apic/es7000_32.c      |   43 ++++--------
 arch/x86/kernel/apic/io_apic.c        |  124 +++++++++++++++++++++-----------
 arch/x86/kernel/apic/numaq_32.c       |   30 +++-----
 arch/x86/kernel/apic/probe_32.c       |   21 +-----
 arch/x86/kernel/apic/summit_32.c      |   41 ++++-------
 arch/x86/kernel/apic/x2apic_cluster.c |   34 ++++++----
 arch/x86/kernel/apic/x2apic_phys.c    |   40 +----------
 arch/x86/kernel/apic/x2apic_uv_x.c    |   44 ++++++------
 arch/x86/platform/uv/uv_irq.c         |    7 ++-
 16 files changed, 291 insertions(+), 405 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
