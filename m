Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab0I0RAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:00:30 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36612 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759342Ab0I0RA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:00:29 -0400
Date: Mon, 27 Sep 2010 19:00:26 +0200
From: Florian Mickler <florian@mickler.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927190026.20ddc268@schatten.dmk.lab>
In-Reply-To: <20100927154441.GE3602@thunk.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1285527125.1732.24.camel@Joe-Laptop>
	<20100927165748.354742f2@schatten.dmk.lab>
	<20100927154441.GE3602@thunk.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 11:44:41 -0400
Ted Ts'o <tytso@mit.edu> wrote:

> On Mon, Sep 27, 2010 at 04:57:48PM +0200, Florian Mickler wrote:
> > 
> > Would in essence have the same effect, but I think it's slightly better
> > to have some shorter tags in the mail addresses, as I expect them to
> > actually show up on lkml quite a bit.
> 
> What if there are no tags on mail addresses that come from the
> MAINTAINERS file, but only tags on the mail addresses that come from
> guessing wildly based on git sign-offs?  People should just be looking
> in the MAINTAINERS file, after all, and I don't think that's something
> that needs an explanation.
> 
> The thing that needs explanation is when someone like Steve Hemminger
> gets cc'ed on a patch for fs/ext4/acl.c, which really makes no sense
> at all, where you desperately need some kind of tag:
> 
> shemminger@vyatta.com (Wild guess using get_maintainer.pl --git)
> 
> 	      	    	  			  - Ted

Might make sense to omit the tags on the MAINTAINER-source. I can
agree to your reasoning there. 


As far as I can see, the use and the use cases for the git-part of
get_maintainer.pl are mostly to get patches to not-so-well-maintained
parts of the tree upstream. What I envision for the git part is a
scoring based classification scheme that uses all readily available
information of the git-history to determine relevant people for patch
review and patch routing.

I already have implemented a small parser that extracts that information
out of git-log and makes them available to the script, but didn't have
time to wire it up yet. 

Another improvement (beyond finding a decent heuristic based on the
artifacts 'authorship', 'signed-off-by', 'reviewed-by', 'acked-by',
'committer' and nr-of-lines-changed.. and maybe time) is probably to
not make an arbitrarily 1-Year-Back cut-off, but to check the last N
commits on that region of the tree. (I'm thinking of the more
"settled down" areas of the tree here)
But let's see what I come up with...

Regards,
Flo
