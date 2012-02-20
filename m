Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2BTD4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:56:44 -0500
Received: from 14.mo5.mail-out.ovh.net ([188.165.51.82]:33258 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113Ab2BTD4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:56:43 -0500
X-Greylist: delayed 65615 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 22:56:42 EST
Date: Mon, 20 Feb 2012 04:49:13 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 04/18] ARM: at91: make ST (System Timer) soc independent
Message-ID: <20120220034913.GG29599@game.jcrosoft.org>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
 <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com>
 <4F419246.6080405@gmail.com>
 <20120220013825.GD29599@game.jcrosoft.org>
 <4F41A76D.1070409@gmail.com>
 <20120220030234.GE29599@game.jcrosoft.org>
 <4F41BB20.8000901@gmail.com>
 <20120220032324.GF29599@game.jcrosoft.org>
 <4F41C29D.2090702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F41C29D.2090702@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14156783954614725389
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:48 Mon 20 Feb     , Ryan Mallon wrote:
> On 20/02/12 14:23, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 14:16 Mon 20 Feb     , Ryan Mallon wrote:
> >> On 20/02/12 14:02, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>
> >>> On 12:52 Mon 20 Feb     , Ryan Mallon wrote:
> >>>> On 20/02/12 12:38, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>>
> >>>>> On 11:22 Mon 20 Feb     , Ryan Mallon wrote:
> >>>>>> On 18/02/12 04:49, Nicolas Ferre wrote:
> >>>>>>
> >>>>>>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> >>>>>>>
> >>>>>>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> >>>>>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>>>>>> ---
> >>>>>>>  arch/arm/mach-at91/at91rm9200.c              |    4 +-
> >>>>>>>  arch/arm/mach-at91/at91rm9200_time.c         |   37 ++++++++++++++++----------
> >>>>>>>  arch/arm/mach-at91/generic.h                 |    1 +
> >>>>>>>  arch/arm/mach-at91/include/mach/at91_st.h    |   32 +++++++++++++++-------
> >>>>>>>  arch/arm/mach-at91/include/mach/at91rm9200.h |    2 +-
> >>>>>>>  drivers/watchdog/at91rm9200_wdt.c            |    8 +++---
> >>>>>>>  6 files changed, 53 insertions(+), 31 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> >>>>>>
> >>>>>> Hi Jean, Nicolas,
> >>>>>>
> >>>>>> Patch looks mostly good, couple of points below.
> >>>>>>
> >>>>>> ~Ryan
> >>>>>>
> >>>>>> <snip>
> >>>>>>
> >>>>>>>  	/* Cancel any pending alarm; flush any pending IRQ */
> >>>>>>> -	at91_sys_write(AT91_ST_RTAR, alm);
> >>>>>>> -	(void) at91_sys_read(AT91_ST_SR);
> >>>>>>> +	at91_st_write(AT91_ST_RTAR, alm);
> >>>>>>> +	(void) at91_st_read(AT91_ST_SR);
> >>>>>>
> >>>>>>
> >>>>>> Can we please remove the (void) casting of the return value when making
> >>>>>> this change, especially since at91_st_read is now a macro which doesn't
> >>>>>> even have a return value. Same in a few other places.
> >>>>> modification done by script and it's no the scope of this patch
> >>>>
> >>>>
> >>>> That isn't an excuse to leave incorrect code there. It is a simple fix.
> >>> no (void) in c means you don't care of the return so basically it's right
> >>
> >>
> >> Because of the way the __raw_writel is defined you are casting the
> >> result of an assignment, basically you are doing this:
> >>
> >>    int foo, bar;
> >>
> >>   (void)(foo = bar);
> >>
> >> Which is pointless. Don't make excuses for silly, redundant code. Fix
> >> it, please.
> > except it's a read it has nothing to do with that
> 
> 
> It makes no difference, it is still equally pointless. We don't cast
> unused return values to void, for functions or assignments, in the kernel.
> 
> It is pointless, superfluous code, and now is a really good opportunity
> to fix it. You can probably even make your script do it for you :-).
I do not want to do 2 thinks at the same time
[
if there is a need to o fix this, it must be done in other patch bisectable

Best Regards,
J.
