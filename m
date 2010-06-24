Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0FXOlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:41:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0FXOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:38:52 -0400
Message-Id: <20100624142804.431553874@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 24 Jun 2010 16:28:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 00/11] perf pmu interface -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches prepare the perf code for multiple pmus (no user
interface yet, Lin Ming is working on that). These patches remove all
weak functions and rework the struct pmu interface.

The patches are boot tested on x86_64 and compile tested on: powerpc
(!fsl, what config is that?), sparc and arm (sorry no SH compiler)

On x86 perf stat and record with both software and hardware events still worked.

I changed all (hardware) pmu implementations so there's a fair chance I messed
something up, please have a look at it.

If people agree with this, I'll continue with the per-pmu context stuff I
talked about last time, which should get us the hardware write batching back.

