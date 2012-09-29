Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913Ab2I2UJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:09:34 -0400
Received: from 5.mo5.mail-out.ovh.net ([87.98.173.103]:38850 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750785Ab2I2UJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:09:32 -0400
X-Greylist: delayed 119997 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2012 16:09:32 EDT
Date: Sat, 29 Sep 2012 21:57:54 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20120929195754.GC17667@game.jcrosoft.org>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
 <20120928024744.GV17667@game.jcrosoft.org>
 <50654E57.3080201@antcom.de>
 <20120928075145.GW17667@game.jcrosoft.org>
 <50656522.1050900@antcom.de>
 <20120928090848.GX17667@game.jcrosoft.org>
 <20120928102822.GY17667@game.jcrosoft.org>
 <50658AD0.1050501@antcom.de>
 <20120928160105.GA17667@game.jcrosoft.org>
 <5065ED4F.5070700@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5065ED4F.5070700@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6004142728795564893
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:32 Fri 28 Sep     , Roland Stigge wrote:
> Hi,
> 
> On 28/09/12 18:01, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>Maybe like this, for some struct block *?
> >>
> >>block = set_block_prepare(gc, pins, values, size);
> >>if (block) {
> >>	set_block(gc, block);
> >>	...
> >>	set_block_unprepare(gc, block);
> >>}
> >>
> >>Would mean that all supported drivers would need to implement those 3
> >>new functions... Need to be careful about not introducing bloat...
> >the prepare is gpiolib specific, it will be a helper to conver a gpio list to
> >a gpio block list
> >
> >I was thinking more
> >
> >block = gpio_block_prepare(pins, size);
> >
> >gpio_block_set_value(pin0, val);
> >gpio_block_set_value(pin1, val);
> >gpio_block_set_value(pin2, val);
> >gpio_block_set(block);
> >
> >andfor get
> >
> >gpio_block_get(block)
> >val = gpio_block_get_value(block, pin0);
> >val = gpio_block_get_value(block, pin1);
> >
> >for the gpio driver ti's transparent
> 
> Problem here is that it's only an intermediate format since hardware
> often needs special preparation of the data.
> 
> But will evaluate what makes most sense.
the key point here is to avoid to manipualte data each time we call
gpio_block_set

hardware specific will have to be handle at driver level

Best Regards,
J.
