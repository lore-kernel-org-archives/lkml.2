Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2BVQec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:34:32 -0500
Received: from 9.mo5.mail-out.ovh.net ([178.32.96.204]:34436 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750888Ab2BVQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:34:31 -0500
Date: Wed, 22 Feb 2012 17:26:31 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com, linux@arm.linux.org.uk
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 02/19] ARM: at91/at91x40: remove use of
 at91_sys_read/write
Message-ID: <20120222162631.GE9407@game.jcrosoft.org>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
 <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
 <201202221436.29474.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202221436.29474.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1806506402640276228
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

On 14:36 Wed 22 Feb     , Arnd Bergmann wrote:
> Hi Nicolas and Jean-Christophe,
> 
> On Wednesday 22 February 2012, Nicolas Ferre wrote:
> > --- a/arch/arm/mach-at91/at91x40.c
> > +++ b/arch/arm/mach-at91/at91x40.c
> > @@ -44,7 +44,7 @@ static void at91x40_idle(void)
> >          * Disable the processor clock.  The processor will be automatically
> >          * re-enabled by an interrupt or by a reset.
> >          */
> > -       at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
> > +       __raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
> >         cpu_do_idle();
> >  }
> 
> How about making this writel_relaxed in the process?
> I would like to see the use of __raw_*() get reduced in code that gets
> touched. In most cases writel_relaxed/readl_relaxed is the correct
> accessor function instead.
It will for next release I plan to switch all of the at one

today I don't want to change it as the same time

Best Regards,
J.
