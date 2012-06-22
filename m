Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2FVOiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:38:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:40029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762132Ab2FVOiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:38:21 -0400
Message-ID: <1340375872.18025.77.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, minchan@gmail.com,
        kosaki.motohiro@gmail.com, andi@firstfloor.org, hannes@cmpxchg.org,
        mel@csn.ul.ie, linux-kernel@vger.kernel.org
Date: Fri, 22 Jun 2012 16:37:52 +0200
In-Reply-To: <4FE48054.5090407@redhat.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	   <1340315835-28571-2-git-send-email-riel@surriel.com>
	  <1340359115.18025.57.camel@twins> <4FE47D0E.3000804@redhat.com>
	 <1340374439.18025.75.camel@twins> <4FE48054.5090407@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 10:25 -0400, Rik van Riel wrote:
> On 06/22/2012 10:13 AM, Peter Zijlstra wrote:
> > On Fri, 2012-06-22 at 10:11 -0400, Rik van Riel wrote:
> >>
> >> I am still trying to wrap my brain around your alternative
> >> search algorithm, not sure if/how it can be combined with
> >> arbitrary address limits and alignment...
> >
> > for alignment we can do: len += align - 1;
> 
> We could, but that might lead us to returning -ENOMEM
> when we actually have memory available.
> 
> When you consider architectures like HPPA, which use
> a pretty large alignment, but align everything the same,
> chances are pretty much every freed hole will have the
> right alignment...

Well, if you don't your gap heap is next to useless and you'll revert to
simply walking all gaps until you find a suitable one.

I really worry about this search function of yours, its complexity is
very non obvious.
