Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2KYIrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 03:47:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54132 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2KYIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 03:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121123173205.GZ8218@suse.de>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
	<20121123173205.GZ8218@suse.de>
Date: Sun, 25 Nov 2012 16:47:15 +0800
Message-ID: <CAJd=RBCUZn4gvzAME0Xm98TCBRnY_201R3dkKaWMySYr4hNmFA@mail.gmail.com>
Subject: Re: Comparison between three trees (was: Latest numa/core release, v17)
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/12, Mel Gorman <mgorman@suse.de> wrote:
> Warning: This is an insanely long mail and there a lot of data here. Get
> 	coffee or something.
>
> This is another round of comparisons between the latest released versions
> of each of three automatic numa balancing trees that are out there.
>
> From the series "Automatic NUMA Balancing V5", the kernels tested were
>
> stats-v5r1	Patches 1-10. TLB optimisations, migration stats
> thpmigrate-v5r1	Patches 1-37. Basic placement policy, PMD handling, THP
> migration etc.
> adaptscan-v5r1	Patches 1-38. Heavy handed PTE scan reduction
> delaystart-v5r1 Patches 1-40. Delay the PTE scan until running on a new
> node
>
> If I just say balancenuma, I mean the "delaystart-v5r1" kernel. The other
> kernels are included so you can see the impact the scan rate adaption
> patch has and what that might mean for a placement policy using a proper
> feedback mechanism.
>
> The other two kernels were
>
> numacore-20121123 It was no longer clear what the deltas between releases
> and
> 	the dependencies might be so I just pulled tip/master on November
> 	23rd, 2012. An earlier pull had serious difficulties and the patch
> 	responsible has been dropped since. This is not a like-with-like
> 	comparison as the tree contains numerous other patches but it's
> 	the best available given the timeframe
>
> autonuma-v28fast This is a rebased version of Andrea's autonuma-v28fast
> 	branch with Hugh's THP migration patch on top.

FYI, based on how target huge page is selected,

+
+	new_page = alloc_pages_node(numa_node_id(),
+		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);

the thp replacement policy is changed to be MORON,

+	/* Migrate the page towards the node whose CPU is referencing it */
+	if (pol->flags & MPOL_F_MORON)
+		polnid = numa_node_id();


described in
	[PATCH 29/46] mm: numa: Migrate on reference policy
	https://lkml.org/lkml/2012/11/21/228

Hillf
