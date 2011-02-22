Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1BVSCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:02:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52827 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab1BVSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:02:39 -0500
Date: Tue, 22 Feb 2011 19:02:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110222180234.GZ5818@one.firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-9-git-send-email-andi@firstfloor.org> <1298392586.9829.22566.camel@nimitz> <20110222164331.GA31195@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222164331.GA31195@random.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:43:31PM +0100, Andrea Arcangeli wrote:
> On Tue, Feb 22, 2011 at 08:36:26AM -0800, Dave Hansen wrote:
> > On Mon, 2011-02-21 at 11:07 -0800, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > I found it difficult to make sense of transparent huge pages without
> > > having any counters for its actions. Add some counters to vmstat
> > > for allocation of transparent hugepages and fallback to smaller
> > > pages.
> > > 
> > > Optional patch, but useful for development and understanding the system.
> > 
> > Very nice.  I did the same thing, splits-only.  I also found this stuff
> > a must-have for trying to do any work with transparent hugepages.  It's
> > just impossible otherwise.
> 
> This patch is good too. 1 and 8 I think can go in, patch 1 is high
> priority.
> 
> Patches 2-5 I've an hard time to see how they're not hurting
> performance instead of improving it, especially patch 3 looks dead

Well right now THP destroys memory locality and that is a quite bad
regression. Destroying memory locality hurts performance significantly.

In general the assumption that you can get the full policy from the 
vma only is wrong: for local you always have to look at the node 
of the existing page too.

I haven't had any reports of KSM doing so, but it seems better
to fix it in the same way. Don't feel very strongly about KSM
for this though, i guess these parts could be dropped too. I guess
you're right and KSM is a bit of a lost cause for NUMA anyways.
Also in my experience KSM is very little memory usually anyways so
it shouldn't matter too much. I guess I can drop that part if it's
controversal.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
