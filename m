Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab0GPSSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:18:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758754Ab0GPSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100716180701.GA26854@n2100.arm.linux.org.uk>
References: <20100713230352.6781.18644.stgit@angua>
	<1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
	<20100716180701.GA26854@n2100.arm.linux.org.uk>
Date: Fri, 16 Jul 2010 11:17:24 -0700
Message-ID: <AANLkTik_pGP2oI0UQmjiz7BndmvFXDs1G2b9Au15y6n1@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:07 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> I thought Linus' idea was to use:
>
> KBUILD_KCONFIG=file make allnoconfig

See an earlier reply - that is indeed what I suggested, and yes, it
avoids the need to be able to "unselect" things.

However, it turns out that even then you do want to extend the Kconfig
language with the ability to select particular values. Not for boolean
(or even tristate things), but for things that select an integer or
string value etc.

So the "select OPTION=xyz" syntax ends up being a good thing even for
the "-n" (allnoconfig) case too.

And while I think the allnoconfig model has some advantages (the
Kconfig input file ends up being independent of the default values),
that very fact ends up being a disadvantage too (the Kconfig input
file likely ends up being larger, since _hopefully_ the defaults are
sane).

So I'm not at all married to the "allnoconfig" model. It's one way of
doing things, but I think the argument that we should start with the
defaults and modify those instead is not an invalid one.

                     Linus
