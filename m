Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2LGLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:01:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45726 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2LGLBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:01:18 -0500
Date: Fri, 7 Dec 2012 12:01:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/49] Automatic NUMA Balancing v10
Message-ID: <20121207110113.GB21482@gmail.com>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> This is a full release of all the patches so apologies for the 
> flood. [...]

I have yet to process all your mails, but assuming I address all 
your review feedback and the latest unified tree in tip:master 
shows no regression in your testing, would you be willing to 
start using it for ongoing work?

It would make it much easier for me to pick up your 
enhancements, fixes, etc.

> Changelog since V9
>   o Migration scalability                                             (mingo)

To *really* see migration scalability bottlenecks you need to 
remove the migration-bandwidth throttling kludge from your tree 
(or configure it up very high if you want to do it simple).

Some (certainly not all) of the performance regressions you 
reported were certainly due to numa/core code hitting the 
migration codepaths as aggressively as the workload demanded - 
and hitting scalability bottlenecks.

The right approach is to hit scalability bottlenecks and fix 
them.

Thanks,

	Ingo
