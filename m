Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2KGQpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:45:52 -0500
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:42872 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657Ab2KGQpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:45:51 -0500
X-Greylist: delayed 3321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2012 11:45:51 EST
Date: Wed, 7 Nov 2012 16:50:26 +0100
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Royer <nicolas@eukrea.com>, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 2/5] ARM: AT91SAM9G45: same platform data structure for
 all crypto peripherals
Message-ID: <20121107165026.4e64422f@eb-e6520>
In-Reply-To: <20121107152615.GD4576@game.jcrosoft.org>
References: <1352219544-30416-1-git-send-email-nicolas@eukrea.com>
	<20121107152615.GD4576@game.jcrosoft.org>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 9458122168813006252
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepgfhrihgtuceurohnrghrugcuoegvrhhitgesvghukhhrvggrrdgtohhmqeenucfjughrpeffhffvuffkjghfohfogggtgfesthhqredtredtud
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

Le Wed, 7 Nov 2012 16:26:15 +0100,
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> a écrit :
> > @@ -1931,9 +1931,9 @@ static struct platform_device at91sam9g45_aes_device = {
> >  static void __init at91_add_device_aes(void)
> >  {
> >  	struct at_dma_slave	*atslave;
> > -	struct aes_dma_data	*alt_atslave;
> > +	struct crypto_dma_data	*alt_atslave;
> >  
> > -	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> > +	alt_atslave = kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
> we do not check the result of kzalloc ouch
> 
> and why we allocate it?
> 
for both remarks : that's the way it's done in at91_add_device_mci since
75305d768d296a07fd02df9af3e5de326df1c72e
A v2 will follow (and also a fix for at91_add_device_mci).

Eric
