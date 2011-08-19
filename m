Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1HSM0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:26:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HSM0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:26:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: of_iomap() matched with plan iounmap()
Date: Fri, 19 Aug 2011 14:26:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, davidb@codeaurora.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20110818170226.GA16721@huya.qualcomm.com> <20110818.203447.462383652600224162.davem@davemloft.net>
In-Reply-To: <20110818.203447.462383652600224162.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191426.19152.arnd@arndb.de>
X-Provags-ID: V02:K0:ldlMnala9FLYx859/yYlwFWKDwHPsgGaJHysYSpNI3C
 2ELWvcT8NmcnzTxXusJcNJDCtNqzx7pDupZz3uZRQvDV8fvNpD
 NIowF6RZ4eYnsK7CCrRBM6rc0z+33pvo6DxewmobGbjMZnQ9eU
 Xb4epnlLa7FJqbjz/Tq4vDHkzi0j2uEA4oKN2R7WkbfRnP43zu
 wshKvjbHXZr7pDt5yZOuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011, David Miller wrote:
> From: David Brown <davidb@codeaurora.org>
> Date: Thu, 18 Aug 2011 10:02:26 -0700
> 
> > The SPARC target contains of_ioremap() and of_iounmap(), which various
> > drivers use (generally inside of CONFIG_SBUS).
> > 
> > include/linux/of_address.h contains a definition for of_iomap(), but
> > not corresponding unmap call.  Code using this calls the regular
> > iounmap().
> > 
> > Is it safe to assume that of_iomap() will always be based on ioremap()
> > and therefore it is safe to use iounmap(), or would it be better to
> > define another name for drivers to use as the inverse of of_iomap().
> > I'm not sure what to call it, since of_iounmap() is already taken by
> > SPARC.
> 
> It's better to define a matching of_iounmap() interface, even if for
> now it is exactly iounmap()

But the problem is that we need conflicting prototypes for of_iounmap.
Sparc currently has

extern void of_iounmap(struct resource *res, void __iomem *base, unsigned long size);
(as the reverse of of_ioremap)

While we would probably want the generic prototype to be
extern void of_iounmap(void __iomem *base);
(as the reverse of of_iomap)

We could of course change all existing users of of_iounmap on sparc to use
the simpler prototype, because it also just calls iounmap.

	Arnd
