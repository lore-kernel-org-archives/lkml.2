Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab0DPDLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:11:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1500 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab0DPDLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:11:48 -0400
Subject: Re: another cleanup patch gone wrong
From: Joe Perches <joe@perches.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1004161214270.271@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 20:11:46 -0700
Message-ID: <1271387506.2298.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 12:34 +1000, Finn Thain wrote:
> ...but this one was already merged, unfortunately.
> 
> > Use printk_once
> > Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > Convert printks without KERN_<level> to pr_info and pr_cont
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > 
> > diff --git a/drivers/net/mac8390.c b/drivers/net/mac8390.c
> > index 517cee4..8bd09e2 100644 (file)
> > --- a/drivers/net/mac8390.c
> > +++ b/drivers/net/mac8390.c
> > @@ -17,6 +17,8 @@
> >  /* 2002-12-30: Try to support more cards, some clues from NetBSD driver */
> >  /* 2003-12-26: Make sure Asante cards always work. */
> >  
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> 
> Why the macro? You only used it once.

It's used embedded in the pr_<level> functions.
It's used more than once.

> The pr_xxx naming convention belongs to a kernel-wide include file. Is it 
> really a good idea to start repurposing it in .c files?

It's in kernel.h, and yes, it is.
http://lkml.org/lkml/2008/11/12/297

> No, this is pr_err. The driver sets dev->mem_start expecting it to work, 
> obviously.

I suggest you change the levels to what you desire.

You could add yourself to the MAINTAINERS entry for this file.

cheers, Joe


