Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1BVQpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:45:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1BVQpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:45:01 -0500
Date: Tue, 22 Feb 2011 17:43:31 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110222164331.GA31195@random.random>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
 <1298315270-10434-9-git-send-email-andi@firstfloor.org>
 <1298392586.9829.22566.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298392586.9829.22566.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:36:26AM -0800, Dave Hansen wrote:
> On Mon, 2011-02-21 at 11:07 -0800, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > I found it difficult to make sense of transparent huge pages without
> > having any counters for its actions. Add some counters to vmstat
> > for allocation of transparent hugepages and fallback to smaller
> > pages.
> > 
> > Optional patch, but useful for development and understanding the system.
> 
> Very nice.  I did the same thing, splits-only.  I also found this stuff
> a must-have for trying to do any work with transparent hugepages.  It's
> just impossible otherwise.

This patch is good too. 1 and 8 I think can go in, patch 1 is high
priority.

Patches 2-5 I've an hard time to see how they're not hurting
performance instead of improving it, especially patch 3 looks dead
wrong and has no chance by the very design of KSM and by the random
(vma-ignoring) NUMA affinity of PageKSM, patch 3 is most certainly a
regression.

Patch 6-7 I didn't evaluate those yet, they look good, even if low
priority.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>

