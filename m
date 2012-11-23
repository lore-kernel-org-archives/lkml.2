Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2KWMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:48:58 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38856 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2KWMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:48:55 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: "Philip\, Avinash" <avinashphilip@ti.com>,
        "paul\@pwsan.com" <paul@pwsan.com>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson\, Benoit" <b-cousson@ti.com>,
        "Hiremath\, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar\, Chimata" <anilkumar@ti.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss\@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori\, Sekhar" <nsekhar@ti.com>,
        "Hebbar\, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia\, Vaibhav" <vaibhav.bedia@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
	<1353503469-18634-6-git-send-email-avinashphilip@ti.com>
	<20121122205944.GC16716@avionic-0098.adnet.avionic-design.de>
	<518397C60809E147AF5323E0420B992E3E9EE991@DBDE01.ent.ti.com>
	<20121123105110.GA6884@avionic-0098.adnet.avionic-design.de>
	<518397C60809E147AF5323E0420B992E3E9EEAAA@DBDE01.ent.ti.com>
	<20121123111811.GA5072@avionic-0098.adnet.avionic-design.de>
Date: Fri, 23 Nov 2012 13:48:51 +0100
In-Reply-To: <20121123111811.GA5072@avionic-0098.adnet.avionic-design.de>
	(Thierry Reding's message of "Fri, 23 Nov 2012 12:18:11 +0100")
Message-ID: <87mwy8eb7w.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Thierry" == Thierry Reding <thierry.reding@avionic-design.de> writes:

Hi,

 Thierry> Everybody seems to be doing it with a warning, so I guess
 Thierry> that's fine for now. I just find it strange that if you
 Thierry> request the default pin group to be selected when in fact the
 Thierry> hardware doesn't support pinctrl at all you shouldn't be
 Thierry> getting an error either.

There's several different situations:

- Platform without pinctrl support
- Platform with pinctrl support but no pinmux specified in dt for device
  (E.G. pinmux setup in bootloader)
- Pinmux specified in dt
- Some kind of misconfiguration in dt

You could argue that devm_pinctrl_get_select_default() shouldn't return
an error for the first situation, but how should it be able to know the
difference between 2 and 4?

-- 
Bye, Peter Korsgaard
