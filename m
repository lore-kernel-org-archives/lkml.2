Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2CCBHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:07:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2CCBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:07:17 -0500
Date: Fri, 2 Mar 2012 17:07:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] devicetree: Add empty of_platform_populate() for
 !CONFIG_OF_ADDRESS (sparc)
Message-Id: <20120302170715.9f0a67ef.akpm@linux-foundation.org>
In-Reply-To: <4F513990.1030401@ti.com>
References: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca>
	<4F513990.1030401@ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 22:20:16 +0100
"Cousson, Benoit" <b-cousson@ti.com> wrote:

> Hi Grant,
> 
> In fact this patch is not working for build without CONFIG_OF like x86.
> 
> On 2/24/2012 11:06 PM, Grant Likely wrote:
> > --- a/include/linux/of_platform.h
> > +++ b/include/linux/of_platform.h
> > @@ -81,7 +81,7 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
> >   					 struct device *parent);
> >   extern struct platform_device *of_find_device_by_node(struct device_node *np);
> >
> > -#if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
> > +#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
> >   /* Platform devices and busses creation */
> >   extern struct platform_device *of_platform_device_create(struct device_node *np,
> >   						   const char *bus_id,
> > @@ -94,7 +94,15 @@ extern int of_platform_populate(struct device_node *root,
> >   				const struct of_device_id *matches,
> >   				const struct of_dev_auxdata *lookup,
> >   				struct device *parent);
> > -#endif /* !CONFIG_SPARC */
> > +#else
> > +static inline int of_platform_populate(struct device_node *root,
> > +					const struct of_device_id *matches,
> > +					const struct of_dev_auxdata *lookup,
> > +					struct device *parent)
> > +{
> > +	return -ENODEV;
> > +}
> > +#endif /* !CONFIG_OF_ADDRESS */
> >
> >   #endif /* CONFIG_OF_DEVICE */
> 
> Because if CONFIG_OF_DEVICE is not defined, then the stub for 
> of_platform_populate will not be defined either. It should exist for any 
> config without CONFIG_OF.
> 
> Building twl4030 for x86 is actually broken.
> 

All twl is broken.  i386 allmodconfig with this monring's linux-next:

drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1357: error: implicit declaration of function 'of_platform_populate'

