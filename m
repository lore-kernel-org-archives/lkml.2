Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab2EEQEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 12:04:06 -0400
Received: from imr4.ericy.com ([198.24.6.9]:53700 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2EEQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 12:04:04 -0400
Date: Sat, 5 May 2012 09:00:42 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120505160042.GA26922@ericsson.com>
References: <1333580415.23520.29.camel@joe2Laptop>
 <1336168477.11505.6.camel@joe2Laptop>
 <20120504220241.GA6279@sirena.org.uk>
 <1336169378.11505.10.camel@joe2Laptop>
 <20120504221333.GU14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120504221333.GU14230@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 06:13:33PM -0400, Mark Brown wrote:
> On Fri, May 04, 2012 at 03:09:38PM -0700, Joe Perches wrote:
> > On Fri, 2012-05-04 at 23:02 +0100, Mark Brown wrote:
> > > On Fri, May 04, 2012 at 02:54:37PM -0700, Joe Perches wrote:
> 
> > > > > drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))
> 
> > > It'd probably help if you were to supply more analysis as to what the
> > > issues you think you're seeing are - in the cases quoted above
> > > (especially the last one) there's no obvious bug without further
> > > analysis.
> 
> > Likely the || should be &&.
> 
> > 	if (val != foo || test != bar)
> 
Guess that was meant to be 
	if (val != foo || val != bar)

> > is always true when foo != bar
> 
> Right, but you need to look at the code and explain why this is a
> problem.  For example, the case I've left quoted above reads to me like
> the intention is "If the chip isn't one I know doesn't like this then
> let's do it" which is a perfectly sensible thing to write.

I can not really follow your logic here; it is difficult for me to imagine a situation
where anything along the line of
	if (val != 1 || val != 2)
would provide value other than creating confusion. Maybe you can explain that a bit further.

Commit 83ec8225b6 ([media] fintek-cir: add support for newer chip version) suggests
that the code was added to support new chip revisions in addition to old revisions.
What it does instead is to drop support for old revisions. To accomplish that, it would
have been sufficient to replace the define of LOGICAL_DEV_CIR, ie change it from 0x05
to 0x08. That would have been a one-line patch, much simpler than the patch as it was
applied. If the idea was to drop support for old revisions in favor of new ones while
keeping a reference to the old definition, it would have been sufficient to add a comment
next to the definition of LOGICAL_DEV_CIR, without all the code complexity introduced
by the patch.

Maybe the author of the above patch might want to comment.

Thanks,
Guenter
