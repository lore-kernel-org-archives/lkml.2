Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2KGRYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:24:39 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:49901 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752940Ab2KGRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:24:38 -0500
Date: Wed, 7 Nov 2012 18:12:17 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: Nicolas Royer <nicolas@eukrea.com>, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/5 v2] ARM: AT91SAM9G45: same platform data structure
 for all crypto peripherals
Message-ID: <20121107171217.GH4576@game.jcrosoft.org>
References: <20121107152615.GD4576@game.jcrosoft.org>
 <1352305675-21961-1-git-send-email-nicolas@eukrea.com>
 <20121107164523.GG4576@game.jcrosoft.org>
 <20121107175946.01f9dc78@eb-e6520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121107175946.01f9dc78@eb-e6520>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10883511451562519470
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -110
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehinhguihgrnhgrrdgvughunecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -110
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehinhguihgrnhgrrdgvughunecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:59 Wed 07 Nov     , Eric Bénard wrote:
> Hi Jean-Christophe,
> 
> Le Wed, 7 Nov 2012 17:45:23 +0100,
> Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a écrit :
> > > @@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
> > >   * -------------------------------------------------------------------- */
> > >  
> > >  #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_ATMEL_AES_MODULE)
> > > -static struct aes_platform_data aes_data;
> > > +static struct crypto_platform_data aes_data;
> > >  static u64 aes_dmamask = DMA_BIT_MASK(32);
> > >  
> > >  static struct resource aes_resources[] = {
> > > @@ -1931,9 +1931,11 @@ static struct platform_device at91sam9g45_aes_device = {
> > >  static void __init at91_add_device_aes(void)
> > >  {
> > >  	struct at_dma_slave	*atslave;
> > > -	struct aes_dma_data	*alt_atslave;
> > > +	struct crypto_dma_data	*alt_atslave;
> > >  
> > > -	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> > > +	alt_atslave = kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
> > I still not understand why we need to allocate it
> > 
> > just declare it as static
> > 
> last time we had some data static and you asked to alloc them (and
> didn't bother to answer why you required that :
> http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/02779.html ), now
> you ask to declare static something which is allocated (and
> that's already done this way for the mci) : may you please explain why
> so that we get it the right way for next time ?

in the driver yes we write multi instance and generic code but in the platfrom I do not see why

Best Regards,
J.
