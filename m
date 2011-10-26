Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab1JZRPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:15:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab1JZRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:15:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 26 Oct 2011 19:15:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Message-ID: <20111026191517.71f3aa93@stein>
In-Reply-To: <4EA8350D.1080003@xenotime.net>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
	<4EA75759.3050900@xenotime.net>
	<20111026062717.GA10230@gondor.apana.org.au>
	<20111026143347.462fea95@stein>
	<4EA8350D.1080003@xenotime.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26 Randy Dunlap wrote:
> On 10/26/11 05:33, Stefan Richter wrote:
> > On Oct 26 Herbert Xu wrote:
> >> --- a/crypto/Kconfig
> >> +++ b/crypto/Kconfig
> >> @@ -103,6 +103,7 @@ config CRYPTO_MANAGER2
> >>  config CRYPTO_USER
> >>  	tristate "Userspace cryptographic algorithm configuration"
> >>  	select CRYPTO_MANAGER
> >> +	select NET
> >>  	help
> >>  	  Userapace configuration for cryptographic instantiations such as

btw, typo: "Userspace"

> >>  	  cbc(aes).
> >>
> >> Cheers,
> > 
> > If you do it this way, you also need to select everything on which NET
> > depends on.  In v3.1, that would be (only) NLATTR which in turn does not
> > depend on anything else.
[...]
> That's correct, but it's better not to "select" an entire subsystem
> like NET at all.

I agree; I add to my comment the implication that --- as a rule of thumb
--- "select" should be avoided if the option to be selected has further
dependencies.

A downside of "config A\n depends on B" is of course that potential users
of option A who are unaware of option B or not interested in B may miss how
to enable A.  Sometimes, a comment in the Kconfig file can help then.
Example (from linux-2.6.36/drivers/ieee1394/):

comment "PCILynx controller requires I2C"
	depends on IEEE1394 && I2C=n

config IEEE1394_PCILYNX
	tristate "PCILynx controller"
	depends on PCI && IEEE1394 && I2C
	select I2C_ALGOBIT
	help
	  Say Y here if you have an IEEE-1394 controller with the Texas
	  Instruments PCILynx chip.
-- 
Stefan Richter
-=====-==-== =-=- ==-=-
http://arcgraph.de/sr/
