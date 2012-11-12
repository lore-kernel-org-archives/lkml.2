Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2KLXno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:43:44 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:39717 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab2KLXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:43:43 -0500
Date: Mon, 12 Nov 2012 23:43:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Announcement: Enhanced NUMA scheduling with adaptive
 affinity
In-Reply-To: <20121112160451.189715188@chello.nl>
Message-ID: <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com>
References: <20121112160451.189715188@chello.nl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Peter Zijlstra wrote:

> The biggest conceptual addition, beyond the elimination of the home
> node, is that the scheduler is now able to recognize 'private' versus
> 'shared' pages, by carefully analyzing the pattern of how CPUs touch the
> working set pages. The scheduler automatically recognizes tasks that
> share memory with each other (and make dominant use of that memory) -
> versus tasks that allocate and use their working set privately.

That is a key distinction to make and if this really works then that is
major progress.

> This new scheduler code is then able to group tasks that are "memory
> related" via their memory access patterns together: in the NUMA context
> moving them on the same node if possible, and spreading them amongst
> nodes if they use private memory.

What happens if processes memory accesses  are related but the
common set of data does not fit into the memory provided by a single node?

The correct resolution usually is in that case to interleasve the pages
over both nodes in use.

