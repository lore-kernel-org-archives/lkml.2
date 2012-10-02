Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2JBXs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:48:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:19881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab2JBXs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="229791135"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl
Subject: perf PMU support for Haswell v2
Date: Tue,  2 Oct 2012 16:48:20 -0700
Message-Id: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Still open (but no merge stopper): 
Would like to do tx-aborts instead of cpu/tx-aborts/. 
Need a way to handle cpu events that have the same name as 
generic events (e.g. instructions)

-Andi

