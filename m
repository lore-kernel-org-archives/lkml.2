Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2KPU5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:57:33 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:5048 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab2KPU5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:57:32 -0500
Date: Fri, 16 Nov 2012 20:57:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Announcement: Enhanced NUMA scheduling with adaptive
 affinity
In-Reply-To: <20121116155943.GB4271@gmail.com>
Message-ID: <0000013b0b031a8f-e57805ad-a81f-4aa7-9906-ceb99f41210b-000000@email.amazonses.com>
References: <20121112160451.189715188@chello.nl> <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com> <20121113072441.GA21386@gmail.com> <0000013b04769cf2-b57b16c0-5af0-4e7e-a736-e0aa2d4e4e78-000000@email.amazonses.com>
 <20121116155943.GB4271@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Ingo Molnar wrote:

> > The interleaving of memory areas that have an equal amount of
> > shared accesses from multiple nodes is essential to limit the
> > traffic on the interconnect and get top performance.
>
> That is true only if the load is symmetric.

Which is usually true of an HPC workload.

> > I guess through that in a non HPC environment where you are
> > not interested in one specific load running at top speed
> > varying contention on the interconnect and memory busses are
> > acceptable. But this means that HPC loads cannot be auto
> > tuned.
>
> I'm not against improving these workloads (at all) - I just
> pointed out that interleaving isn't necessarily the best
> placement strategy for 'large' workloads.

Depends on what you mean by "large" workloads. If it is a typically large
HPC workload with data structures distributed over nodes then the
placement of those data structure spread over all nodes is the best
placement startegy.
