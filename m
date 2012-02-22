Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2BVSSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:18:08 -0500
Received: from 14.mo5.mail-out.ovh.net ([188.165.51.82]:41997 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754811Ab2BVSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:18:04 -0500
Date: Wed, 22 Feb 2012 19:02:38 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        rmallon@gmail.com
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 12/19] ARM: at91/rtc-at91sam9: each SoC can select
 the RTT device to use
Message-ID: <20120222180238.GH9407@game.jcrosoft.org>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
 <201202221647.23430.arnd@arndb.de>
 <20120222170724.GF9407@game.jcrosoft.org>
 <201202221725.46150.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202221725.46150.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3430054067987655428
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.500001/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:25 Wed 22 Feb     , Arnd Bergmann wrote:
> On Wednesday 22 February 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > But if you change the rtc driver to always bind to the existing
> > > "at91_rtt" platform_device and fail the probe() function for the
> > > case that you are on at91sam9263 probing the non-RTC device,
> > > you should get the exact same result without any extra code
> > > in the per-soc files.
> >
> > agreed but as on at91sam9263 you have 2 RTTs so you can have 2 drivers at the
> > same time that use the RTT. So we can not do this except if we set the second
> > RTT to an other device name.
> 
> Let me rephrase what I meant then:
> 
> The first driver should in its probe function do:
> 
> 	if (pdev->id != CONFIG_RTC_DRV_AT91SAM9_RTT)
> 		return -ENODEV;
> 
> while the other driver does
> 
> 	if (pdev->id == CONFIG_RTC_DRV_AT91SAM9_RTT)
> 		return -ENODEV;
> 
> This way, each driver binds to one device but not the other.
> It should even work with an unmodified second driver, as long
> as you guarantee that it's loaded after the first one.
> 
> Any reason why this won't work?
just one other issue I need to pass the GPBR ressource to the RTC driver only

Best Regards,
J.
