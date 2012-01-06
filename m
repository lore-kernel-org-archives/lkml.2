Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030518Ab2AFTVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:21:40 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32918 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030482Ab2AFTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:21:37 -0500
X-Sasl-enc: kjvmMHfAMOhT8kuu1VATwfJeOpVIAwp12rPqvqch00be 1325877696
Date: Fri, 6 Jan 2012 11:20:02 -0800
From: "'Greg KH'" <greg@kroah.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Nicolas Pitre'" <nicolas.pitre@linaro.org>,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Kay Sievers'" <kay.sievers@vrfy.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the arm
 tree
Message-ID: <20120106192002.GA24244@kroah.com>
References: <20120106175227.07a7240920f3ccd95c27b9a7@canb.auug.org.au>
 <031201cccc41$f24aa320$d6dfe960$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <031201cccc41$f24aa320$d6dfe960$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 04:08:09PM +0900, Kukjin Kim wrote:
> Stephen Rothwell wrote:
> > 
> > Hi Greg,
> > 
> > Today's linux-next merge of the driver-core tree got a conflict in
> > arch/arm/mach-s5pc100/common.c between commit 109ac862f737 ("ARM:
> > mach-s5pc100: use standard arch_idle()") from the arm tree and commit
> > 4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
> > the driver-core tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc arch/arm/mach-s5pc100/common.c
> > index 4659fb9,af52c09..0000000
> > --- a/arch/arm/mach-s5pc100/common.c
> > +++ b/arch/arm/mach-s5pc100/common.c
> > @@@ -194,27 -154,17 +195,27 @@@ static struct device s5pc100_dev =
> > 
> >   static int __init s5pc100_core_init(void)
> >   {
> > - 	return sysdev_class_register(&s5pc100_sysclass);
> > + 	return subsys_system_register(&s5pc100_subsys, NULL);
> >   }
> >  -
> >   core_initcall(s5pc100_core_init);
> > 
> >   int __init s5pc100_init(void)
> >   {
> >   	printk(KERN_INFO "S5PC100: Initializing architecture\n");
> > - 	return sysdev_register(&s5pc100_sysdev);
> > ++	return device_register(&s5pc100_sys);
> 
> Hi Greg,
> 
> Should be 'return device_register(&s5pc100_dev);'?
> 
> Greg,
> Following should be fixed in your driver-core/driver-core-next.
> (I informed that but maybe you missed)

Sorry, I missed this patch.  I'll apply it and take the above merge fix
as well.

greg k-h
