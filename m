Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2BWDdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:33:13 -0500
Received: from 14.mo5.mail-out.ovh.net ([188.165.51.82]:54915 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753508Ab2BWDdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:33:06 -0500
Date: Thu, 23 Feb 2012 04:25:03 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 02/19] ARM: at91/at91x40: remove use of
 at91_sys_read/write
Message-ID: <20120223032503.GA20176@game.jcrosoft.org>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
 <fac36a5ab9fe5a8bd977d2305eeccad48389cbb5.1329903206.git.nicolas.ferre@atmel.com>
 <4F456AAF.3090809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F456AAF.3090809@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12929553057244883725
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:22 Thu 23 Feb     , Ryan Mallon wrote:
> On 22/02/12 20:39, Nicolas Ferre wrote:
> 
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91x40.c              |    2 +-
> >  arch/arm/mach-at91/at91x40_time.c         |   28 +++++++++++++++++-----------
> >  arch/arm/mach-at91/include/mach/at91x40.h |   18 +++++++++---------
> >  3 files changed, 27 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> > index 0154b7f..5400a1d 100644
> > --- a/arch/arm/mach-at91/at91x40.c
> > +++ b/arch/arm/mach-at91/at91x40.c
> > @@ -44,7 +44,7 @@ static void at91x40_idle(void)
> >  	 * Disable the processor clock.  The processor will be automatically
> >  	 * re-enabled by an interrupt or by a reset.
> >  	 */
> > -	at91_sys_write(AT91_PS_CR, AT91_PS_CR_CPU);
> > +	__raw_writel(AT91_PS_CR_CPU, AT91_PS_CR);
> 
> 
> This doesn't seem to be equivalent, at91_sys_write does:
> 
>   void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
>   __raw_writel(value, addr + reg_offset);
> 
> and this patch doesn't redefine AT91_PS_CR. Was it broken before this
> patch? What am I missing?
this is right
#define AT91_PS_CR      (AT91_PS + 0)   /* PS Control register */

Best Regards,
J.
