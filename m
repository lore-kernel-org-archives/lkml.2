Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2KOXZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:25:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2KOXZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:25:23 -0500
Date: Thu, 15 Nov 2012 15:25:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arpith Easow Alexander <arpith99@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: replaced printk with dev_dbg
Message-ID: <20121115232519.GA27558@kroah.com>
References: <20121110070833.GA18391@gmail.com>
 <20121113195252.GA13648@kroah.com>
 <20121115162740.GA10360@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115162740.GA10360@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 09:57:42PM +0530, Arpith Easow Alexander wrote:
> On Tue, Nov 13, 2012 at 11:52:52AM -0800, Greg KH wrote:
> > On Sat, Nov 10, 2012 at 12:38:38PM +0530, Arpith Easow Alexander wrote:
> > > This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
> > > This fixes the warnings found by the checkpatch.pl tool.
> > > 
> > > Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
> > > ---
> > >  drivers/staging/comedi/drivers/vmk80xx.c |   30 ++++++++++++++++++------------
> > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
> > > index df277aa..6eb5361 100644
> > > --- a/drivers/staging/comedi/drivers/vmk80xx.c
> > > +++ b/drivers/staging/comedi/drivers/vmk80xx.c
> > > @@ -131,10 +131,10 @@ static int dbgcm = 1;
> > >  static int dbgcm;
> > >  #endif
> > >  
> > > -#define dbgcm(fmt, arg...)                     \
> > > +#define dbgcm(dev, fmt, arg...)                     \
> > >  do {                                           \
> > >  	if (dbgcm)                             \
> > > -		printk(KERN_DEBUG fmt, ##arg); \
> > > +		dev_dbg(dev, fmt, ##arg); \
> > 
> > So a macro called dbgcm tests a variable called dbgcm?  Gotta love c at
> > times...
> > 
> > Just delete the macro, and the variable, and call dev_dbg() directly
> > please.
> 
> Ok. Done. (Attached both changes).

As Hartley pointed out, I can't take patches as attachments, one per
email please.

thanks,

greg k-h
