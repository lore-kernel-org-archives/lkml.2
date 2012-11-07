Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2KGWZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:25:51 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:39995 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751471Ab2KGWZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:25:50 -0500
Date: Wed, 7 Nov 2012 17:59:46 +0100
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Royer <nicolas@eukrea.com>, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 2/5 v2] ARM: AT91SAM9G45: same platform data structure
 for all crypto peripherals
Message-ID: <20121107175946.01f9dc78@eb-e6520>
In-Reply-To: <20121107164523.GG4576@game.jcrosoft.org>
References: <20121107152615.GD4576@game.jcrosoft.org>
	<1352305675-21961-1-git-send-email-nicolas@eukrea.com>
	<20121107164523.GG4576@game.jcrosoft.org>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 10629339546849553836
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -110
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepihhnughirghnrgdrvgguuhenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -110
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucffohhmrghinhepihhnughirghnrgdrvgguuhenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

Le Wed, 7 Nov 2012 17:45:23 +0100,
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a écrit :
> > @@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
> >   * -------------------------------------------------------------------- */
> >  
> >  #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_ATMEL_AES_MODULE)
> > -static struct aes_platform_data aes_data;
> > +static struct crypto_platform_data aes_data;
> >  static u64 aes_dmamask = DMA_BIT_MASK(32);
> >  
> >  static struct resource aes_resources[] = {
> > @@ -1931,9 +1931,11 @@ static struct platform_device at91sam9g45_aes_device = {
> >  static void __init at91_add_device_aes(void)
> >  {
> >  	struct at_dma_slave	*atslave;
> > -	struct aes_dma_data	*alt_atslave;
> > +	struct crypto_dma_data	*alt_atslave;
> >  
> > -	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> > +	alt_atslave = kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
> I still not understand why we need to allocate it
> 
> just declare it as static
> 
last time we had some data static and you asked to alloc them (and
didn't bother to answer why you required that :
http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/02779.html ), now
you ask to declare static something which is allocated (and
that's already done this way for the mci) : may you please explain why
so that we get it the right way for next time ?

Thanks
Eric
