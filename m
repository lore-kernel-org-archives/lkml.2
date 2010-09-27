Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab0I0SVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:21:35 -0400
Received: from thunk.org ([69.25.196.29]:58507 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab0I0SVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:21:34 -0400
Date: Mon, 27 Sep 2010 14:21:24 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Florian Mickler <florian@mickler.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927182124.GA3168@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Florian Mickler <florian@mickler.org>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1285527125.1732.24.camel@Joe-Laptop>
 <20100927165748.354742f2@schatten.dmk.lab>
 <20100927154441.GE3602@thunk.org>
 <20100927190026.20ddc268@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927190026.20ddc268@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 07:00:26PM +0200, Florian Mickler wrote:
> 
> Another improvement (beyond finding a decent heuristic based on the
> artifacts 'authorship', 'signed-off-by', 'reviewed-by', 'acked-by',
> 'committer' and nr-of-lines-changed.. and maybe time) is probably to
> not make an arbitrarily 1-Year-Back cut-off, but to check the last N
> commits on that region of the tree. (I'm thinking of the more
> "settled down" areas of the tree here)
> But let's see what I come up with...

I'd suggest a "stop list" of keywords that would cause a commit not be
considered at all.  i.e., words like "trivial" (the trivial tree often
bypasses the subsystem maintainer, and you don't want to identify
someone as the maintainer just because they submitted a change to
change "colour" to "color"), "checkpatch", or "cleanup".

The other thing I'd suggest is try to figure out hueristics when the
git log analysis should be expanded beyond the file which was
modified, to the subdirctory.  That is, if the patch touches a file
that rarely changes except for one spelling fix in the past year, but
the subsystem or device driver has activity in other files in that
subdirectory, it would be nice if get_maintainer.pl at least _tried_
to figure out this case of (for example)
drivers/media/video/omap/omap_voutlib.c has only one change in the
past year, and doesn't have an entry in MAINTAINERS, the history of
the subdirectory drivers/media/video/omap/ might be a better thing to
use when deciding who to bug about some trivial spelling chnage in
omap_voutlib.c.

Really, though, the right answer is to keep the MAINTAINERS file up to
date enough that we don't have to resort to having scripts attempt to
solve the AI problem.  (I've argued for not even trying, but clearly
people who have tried to argue for that have lost that battle; enough
people seem to think it's worth while to make wild guesses even though
the script is called get_maintainer.pl, and not
get_maintainer_or_make_wild_stabs_in_the_dark.pl.)

						- Ted

P.S.  Wouldn't it be better to train kernel newbies how to read
through the output of git log themselves?  I'm not sure that training
people to rely blindly on dumb scripts is in the end actually going to
be doing ourselves and the whole community a service.  Sigh....
