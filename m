Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab1CCQm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:42:29 -0500
Received: from xenotime.net ([184.105.210.51]:49639 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758263Ab1CCQm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:42:28 -0500
Date: Thu, 3 Mar 2011 08:42:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jinqiu <crindy646@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
Message-Id: <20110303084221.281ccadb.rdunlap@xenotime.net>
In-Reply-To: <4D6F01DA.3040307@cn.fujitsu.com>
References: <4D6EFAE5.4000400@gmail.com>
	<4D6F01DA.3040307@cn.fujitsu.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Mar 2011 10:50:02 +0800 Li Zefan wrote:

> So you've been told to read Documentation/SubmittingPatches
> and Documentation/email-clients.txt, but there are still quite
> a few problems in your patch..
> 
> Don't ever mention "bug #13853", because this number makes no sense
> for everyone except you. A proper subject may be:
> 
> [PATCH] ariadne: fix possible null dereference.
> 
> And please send your patches to proper maintainers and mailing list,
> David Miller and netdev@vger.kernel.org in particular.
> 
> Jinqiu wrote:
> > This patch fixes bug #13853 .This still exists in latest version.
> 
> Of course it exists, otherwise your patch won't be applied, so just
> remove this line from your changelog.
> 
> > 'dev' is dereferenced before testing for NULL.
> > 
> > Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
> > --- a/drivers/net/ariadne.c
> > +++ b/drivers/net/ariadne.c
> > @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
> > static irqreturn_t ariadne_interrupt(int irq, void *data)
> > {
> >     struct net_device *dev = (struct net_device *) data;
> > -     volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
> > +     volatile struct Am79C960 *lance;
> 
> You still haven't fix your email client. You should notice the tabs have
> been turned into spaces.

Uh, ariadne.c does not use tabs to begin its lines... it uses spaces.  :(

> Please make sure you fix this (and other issues) before sending out the
> patch again.
> 
> >     struct ariadne_private *priv;
> >     int csr0, boguscnt;
> >     int handled = 0;
> > @@ -429,6 +429, 7 @@ static irqreturn_t ariadne_interrupt(int
> >         printk(KERN_WARNING  "ariadne_interrupt(): irq for unknown device.\n");
> >         return IRQ_NONE;
> >     }
> > +     lance = (struct Am79C960 *)dev->base_addr;
> > 
> >     lance->RAP = CSR0;                     /* PCnet-ISA Controller Status */
> > 
> > 
> > 
> > 
> > -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
