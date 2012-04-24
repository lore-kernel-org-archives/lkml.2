Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2DXTeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:34:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab2DXTeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:34:13 -0400
Message-ID: <1335296032.28150.224.camel@twins>
Subject: Re: [PATCH 1/3] Range tree implementation
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 21:33:52 +0200
In-Reply-To: <4F96FE1D.8040906@linaro.org>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
	 <1335289787-11089-2-git-send-email-john.stultz@linaro.org>
	 <1335294860.28150.219.camel@twins> <4F96FE1D.8040906@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 12:25 -0700, John Stultz wrote:
> On 04/24/2012 12:14 PM, Peter Zijlstra wrote:
> > On Tue, 2012-04-24 at 10:49 -0700, John Stultz wrote:
> >> This makes it
> >> very difficult to provide generic list_head like behavior, as
> >> the parent structures would need to be duplicated and removed,
> >> and that has lots of memory ownership issues.
> > You can in fact modify the rb-tree to have O(1) iteration by using the
> > empty leaf pointers to keep pointers to next/prev nodes.
> >
> > Its a bit of a bother since you'd need to wrap ->rb_left and ->rb_right
> > in functions.. but now that we have coccinelle that shouldn't actually
> > be too hard.
> >
> Sorry, I'm not sure I'm following you.
> 
> My point above was that a generic range-tree implementation that manages 
> the splitting and coalescing of ranges internally is difficult, due to 
> memory ownership issues.  This makes it hard to have a generic list_head 
> style structure that you can use in your own structures. Thus in a way 
> similar to how the rb_tree leaves the insert and search implementation 
> to the suers,  there is a range_tree_node structure, and the splitting 
> and coalescing logic is left to the range-tree user.
> 
> Does your suggestion address the ownership issue differently?  Or is it 
> just a general optimization improvement?

Oh, I thought you also wanted a list_head to aid in the traversal
required to find adjacent ranges etc.. 

Brain completely failed to grasp what you were trying to say, sorry for
the noise. 
