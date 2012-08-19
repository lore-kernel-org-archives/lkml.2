Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2HSGhv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 02:37:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35366 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab2HSGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 02:37:47 -0400
X-Sasl-enc: vh7iak6oNmY4k9g3sNMNrLIHHzamW08bY3Ggjvktpc2r 1345358266
Date: Sat, 18 Aug 2012 23:37:45 -0700
From: Greg KH <gregkh@linux-foundation.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] dyndbg: fix for SOH in logging messages
Message-ID: <20120819063745.GA1943@kroah.com>
References: <1345336551-10066-1-git-send-email-jim.cromie@gmail.com>
 <20120819061352.GA1971@kroah.com>
 <20120819063302.GA6182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819063302.GA6182@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 11:33:02PM -0700, Greg KH wrote:
> On Sat, Aug 18, 2012 at 11:13:52PM -0700, Greg KH wrote:
> > On Sat, Aug 18, 2012 at 06:35:51PM -0600, Jim Cromie wrote:
> > > commit af7f2158fde was done against master, and clashed with structured logging's change of KERN_LEVEL to SOH.
> > > 
> > > Bisected and fixed by Markus Trippelsdorf.
> > > 
> > > CC: Markus Trippelsdorf <markus@trippelsdorf.de>
> > > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> > > ---
> > >  drivers/base/core.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > index cdd01c5..5e6e00b 100644
> > > --- a/drivers/base/core.c
> > > +++ b/drivers/base/core.c
> > > @@ -1912,8 +1912,8 @@ int __dev_printk(const char *level, const struct device *dev,
> > >  				    "DEVICE=+%s:%s", subsys, dev_name(dev));
> > >  	}
> > >  skip:
> > > -	if (level[3])
> > > -		level_extra = &level[3]; /* skip past "<L>" */
> > > +	if (level[2])
> > > +		level_extra = &level[2]; /* skip past KERN_SOH "L" */
> > >  
> > >  	return printk_emit(0, level[1] - '0',
> > >  			   dictlen ? dict : NULL, dictlen,
> > 
> > No, this still doesn't resolve the issue for me, it still looks like it
> > did before this patch (exactly the same to be exact.)
> > 
> > I do seem to get the correct output if I revert your original patch
> > (af7f2158fde), should I just do that instead?
> 
> Crap, no, sorry, it's late, I didn't apply your patch at all (--dry-run
> only, my bad).
> 
> Let me go test this for real now, my applogies...

And it works, sorry for the noise, I'll go queue it up now.

greg k-h
