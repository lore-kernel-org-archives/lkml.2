Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1EUGu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 02:50:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32886 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1EUGuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 02:50:21 -0400
Date: Sat, 21 May 2011 08:48:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] check_signature depends on CONFIG_CHECK_SIGNATURE
Message-ID: <20110521084845.0400015d@endymion.delvare>
In-Reply-To: <20110520151113.645dbbe7.akpm@linux-foundation.org>
References: <20110520161448.375eb634@endymion.delvare>
	<20110520151113.645dbbe7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 20 May 2011 15:11:13 -0700, Andrew Morton wrote:
> On Fri, 20 May 2011 16:14:48 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > check_signature() is only available if CONFIG_CHECK_SIGNATURE has been
> > selected. Don't declare the function if it won't be available at link
> > time. That way, any failure to select CONFIG_CHECK_SIGNATURE as needed
> > will show up immediately at build time.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  include/linux/io.h |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.40-rc0.orig/include/linux/io.h	2011-05-20 10:41:02.000000000 +0200
> > +++ linux-2.6.40-rc0/include/linux/io.h	2011-05-20 16:00:31.000000000 +0200
> > @@ -63,8 +63,11 @@ void __iomem *devm_ioremap(struct device
> >  void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
> >  				    unsigned long size);
> >  void devm_iounmap(struct device *dev, void __iomem *addr);
> > +void devm_ioremap_release(struct device *dev, void *res);
> > +
> > +#ifdef CONFIG_CHECK_SIGNATURE
> >  int check_signature(const volatile void __iomem *io_addr,
> >  			const unsigned char *signature, int length);
> > -void devm_ioremap_release(struct device *dev, void *res);
> > +#endif
> 
> We usually avoid doing this.  Detecting the error at link time is
> sufficient.
> 
> Yes, that will very occasionally cost a small number of people a little
> additional time.  But we must balance that against permanently messing
> up the header files.

OK, fair enough. Patch deleted.

-- 
Jean Delvare
