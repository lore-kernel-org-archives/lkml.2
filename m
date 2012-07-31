Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2GaWAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:00:22 -0400
Received: from ozlabs.org ([203.10.76.45]:56970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab2GaWAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:00:20 -0400
From: Michael Neuling <mikey@neuling.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, anton@samba.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: CRYPTO_DEV_NX merge problem (Re: linux-next: Tree for July 31)
In-reply-to: <5017DE06.3000103@linux.vnet.ibm.com>
References: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au> <31974.1343714338@neuling.org> <5017DE06.3000103@linux.vnet.ibm.com>
Comments: In-reply-to Seth Jennings <sjenning@linux.vnet.ibm.com>
   message dated "Tue, 31 Jul 2012 08:30:46 -0500."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Wed, 01 Aug 2012 08:00:18 +1000
Message-ID: <19970.1343772018@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:

> On 07/31/2012 12:58 AM, Michael Neuling wrote:
> >> Please do not add anything to linux-next included branches/series that is
> >> destined for v3.7 until after v3.6-rc1 is released.
> > 
> > Looks like there is a merge conflict between:
> >   commit 1b074ac867a2bd08a6f12f0feed7d91e06941723
> >   Author: Seth Jennings <sjenning@linux.vnet.ibm.com>
> >   Subject: powerpc/crypto: rework Kconfig
> > 
> > and 
> >   commit fd297b3a7302ab866306f53c1fd1e97b083fe83e
> >   Author: Anton Blanchard <anton@samba.org>
> >   powerpc: Enable pseries hardware RNG and crypto modules
> > 
> > Seth made CRYPTO_DEV_NX a bool and Anton set it as a module.
> > 
> > Hence I get this with a pseries_defconfig
> >   arch/powerpc/configs/pseries_defconfig:372:warning: symbol value 'm' invalid for CRYPTO_DEV_NX
> > 
> > Seth: any reason this can stay as a tristate?
> 
> My patch converted CRYPTO_DEV_NX to a submenu access config
> and the functionality that used to be enabled by it is now
> enabled by CRYPTO_DEV_NX_ENCRYPT.
> 
> The resolution is to change Anton's patch from
> 
> +CONFIG_CRYPTO_DEV_NX=m
> 
> to
> 
> +CONFIG_CRYPTO_DEV_NX=y
> +CONFIG_CRYPTO_DEV_NX_ENCRYPT=m

Seth,  

OK.  Please post the fix as a patch.  Anton's patch is already in the
powerpc next tree so it won't be changed/rebased directly.  

I'm not sure who can carry this, since the crypto tree doesn't have
Anton's change and the powerpc tree doesn't have Seth's change.

sfr: who normally carries it when we have a merge issue like this?  You?

Mikey

