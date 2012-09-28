Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2I1Ebz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:31:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:42307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2I1Ebw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215093224"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com
Subject: perf PMU support for Haswell
Date: Thu, 27 Sep 2012 21:31:05 -0700
Message-Id: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
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
- Generic transactional memory events, plus Haswell implementations.
- Generic weightend profiling for memory latency and transaction abort costs.
- Support for address profiling
- Support for filtering events inside/outside transactions
- KVM support to do this from guests
- Support for filtering/sorting/bucketing transaction abort types based on 
PEBS information
- LBR support for transactions

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

Review appreciated.

-Andi

