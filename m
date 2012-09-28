Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2I1QDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:03:37 -0400
Received: from 13.mo3.mail-out.ovh.net ([188.165.33.202]:55121 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756195Ab2I1QDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:03:36 -0400
X-Greylist: delayed 47222 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 12:03:35 EDT
Date: Fri, 28 Sep 2012 18:01:05 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20120928160105.GA17667@game.jcrosoft.org>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
 <20120928024744.GV17667@game.jcrosoft.org>
 <50654E57.3080201@antcom.de>
 <20120928075145.GW17667@game.jcrosoft.org>
 <50656522.1050900@antcom.de>
 <20120928090848.GX17667@game.jcrosoft.org>
 <20120928102822.GY17667@game.jcrosoft.org>
 <50658AD0.1050501@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50658AD0.1050501@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14579840844335524701
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:32 Fri 28 Sep     , Roland Stigge wrote:
> On 09/28/2012 12:28 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> gpio0 = {1};
> >> set0 = {1};
> >>
> >> gpio1 = {33, 34};
> > here should be
> > 
> > pin0 = {1};
> > set0 = {1};
> > 
> > pin1 = {1, 2, 23};
> > set1 = {0, 0, 1};
> > 
> > set_blocks(gpio_chip0, pin0, set0, 1);
> > set_blocks(gpio_chip1, pin1, set1, 3);
> > 
> > You may need to add a prepare to do not do the conversion between array and
> > gpio_chip array as I guess you will work on gpio block with multiple time
> > acces
> 
> Maybe like this, for some struct block *?
> 
> block = set_block_prepare(gc, pins, values, size);
> if (block) {
> 	set_block(gc, block);
> 	...
> 	set_block_unprepare(gc, block);
> }
> 
> Would mean that all supported drivers would need to implement those 3
> new functions... Need to be careful about not introducing bloat...
the prepare is gpiolib specific, it will be a helper to conver a gpio list to
a gpio block list

I was thinking more

block = gpio_block_prepare(pins, size);

gpio_block_set_value(pin0, val);
gpio_block_set_value(pin1, val);
gpio_block_set_value(pin2, val);
gpio_block_set(block);

andfor get

gpio_block_get(block)
val = gpio_block_get_value(block, pin0);
val = gpio_block_get_value(block, pin1);

for the gpio driver ti's transparent

Best Regards,
J.
