Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab1CCCsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:48:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab1CCCsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:48:02 -0500
Message-ID: <4D6F01DA.3040307@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 10:50:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jinqiu <crindy646@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
References: <4D6EFAE5.4000400@gmail.com>
In-Reply-To: <4D6EFAE5.4000400@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 10:46:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 10:46:47,
	Serialize complete at 2011-03-03 10:46:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So you've been told to read Documentation/SubmittingPatches
and Documentation/email-clients.txt, but there are still quite
a few problems in your patch..

Don't ever mention "bug #13853", because this number makes no sense
for everyone except you. A proper subject may be:

[PATCH] ariadne: fix possible null dereference.

And please send your patches to proper maintainers and mailing list,
David Miller and netdev@vger.kernel.org in particular.

Jinqiu wrote:
> This patch fixes bug #13853 .This still exists in latest version.

Of course it exists, otherwise your patch won't be applied, so just
remove this line from your changelog.

> 'dev' is dereferenced before testing for NULL.
> 
> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
> --- a/drivers/net/ariadne.c
> +++ b/drivers/net/ariadne.c
> @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
> static irqreturn_t ariadne_interrupt(int irq, void *data)
> {
>     struct net_device *dev = (struct net_device *) data;
> -     volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
> +     volatile struct Am79C960 *lance;

You still haven't fix your email client. You should notice the tabs have
been turned into spaces.

Please make sure you fix this (and other issues) before sending out the
patch again.

>     struct ariadne_private *priv;
>     int csr0, boguscnt;
>     int handled = 0;
> @@ -429,6 +429, 7 @@ static irqreturn_t ariadne_interrupt(int
>         printk(KERN_WARNING  "ariadne_interrupt(): irq for unknown device.\n");
>         return IRQ_NONE;
>     }
> +     lance = (struct Am79C960 *)dev->base_addr;
> 
>     lance->RAP = CSR0;                     /* PCnet-ISA Controller Status */
> 
> 
> 
> 
> -- 
