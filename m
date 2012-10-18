Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2JRXTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:19:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:28177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab2JRXTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="206293152"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com
Subject: perf PMU support for Haswell v3
Date: Thu, 18 Oct 2012 16:19:08 -0700
Message-Id: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Updated version for the latest master tree and various fixes.
See end for details. This should be ready for merging now I hope.]

This adds perf PMU support for the upcoming Haswell core. The patchkit 
is fairly large, mainly due to various enhancement for TSX. TSX tuning
relies heavily on the PMU, so I tried hard to make all facilities 
easily available. In addition it also has some other enhancements.

This includes changes to the core perf code, to the x86 specific part,
to the perf user land tools and to KVM

High level overview:

- Basic Haswell PMU support
- Easy high level TSX measurement in perf stat -T
- Transaction events and attributes implemented with sysfs enumeration
- Export arch perfmon events in sysfs 
- Generic weightend profiling for memory latency and transaction abort costs.
- Support for address profiling
- Support for filtering events inside/outside transactions
- KVM support to do this from guests
- Support for filtering/sorting/bucketing transaction abort types based on 
PEBS information
- LBR support for transactions

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

Some of the added features could be added to older CPUs too. I plan
to do this, but in separate patches.

Review appreciated.

v2: Removed generic transaction events and qualifiers and use sysfs
enumeration. Also export arch perfmon, so that the qualifiers work.
Fixed various issues this exposed. Don't use a special macro for the
TSX constraints anymore. Address other review feedback.
Added pdir event in sysfs.

v3: Fix various bugs and address review comments.
tx-aborts instead of cpu/tx-aborts/ works now (with some limitations)
cpu/instructions,intx=1/ works now

Open issues:
I tried to test the KVM support again, but there seems to be some generic
problem that prevents it from doing PMU emulation.

-Andi
