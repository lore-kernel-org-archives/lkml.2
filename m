Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2BVNGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:06:31 -0500
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:41583 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585Ab2BVNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:06:29 -0500
Date: Wed, 22 Feb 2012 13:58:14 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 07/19] ARM: at91/pm_slowclock: function slow_clock()
 accepts parameters
Message-ID: <20120222125814.GA9407@game.jcrosoft.org>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
 <5b8fbdf669825987a82b3b89b2e7f02239cad816.1329903206.git.nicolas.ferre@atmel.com>
 <20120222095250.GV22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222095250.GV22562@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16735094740513958835
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:52 Wed 22 Feb     , Russell King - ARM Linux wrote:
> On Wed, Feb 22, 2012 at 10:39:33AM +0100, Nicolas Ferre wrote:
> > @@ -232,7 +246,7 @@ static int at91_pm_enter(suspend_state_t state)
> >  				/* copy slow_clock handler to SRAM, and call it */
> >  				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> >  #endif
> > -				slow_clock();
> > +				slow_clock(at91_pmc_base, at91_ramc0_base, at91_ramc1_base);
> 
> This should be updated to use the fncpy() stuff if there's any chance that
> you'll be supporting Thumb-2.  Using fncpy() is probably a good idea even
> if you aren't.  See asm/fncpy.h
Yes I agree and I plan to do it
but I'm work first on the update of the genalloc api to use it here to allocate
the address in sram

If it's ok with you I'll do it after

Btw I'm looking on a way to switch the assembly funciton to C but I didn,t find a
good way to calculate the function size except by touching at the linker
script. Which I don;t want to do.

Do you have any idea?

Best Regards,
J.
