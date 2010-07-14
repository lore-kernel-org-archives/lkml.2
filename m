Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0GNPrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:47:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36171 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427Ab0GNPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:47:29 -0400
Date: Wed, 14 Jul 2010 16:47:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar R IYER <sundar.iyer@stericsson.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100714154726.GH31073@rakim.wolfsonmicro.main>
References: <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
 <20100713203852.GA1756@rakim.wolfsonmicro.main>
 <20100714145053.GA1689@bnru01.bnr.st.com>
 <20100714145748.GF31073@rakim.wolfsonmicro.main>
 <20100714153643.GB1689@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714153643.GB1689@bnru01.bnr.st.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:06:44PM +0530, Sundar R IYER wrote:

> > Which datasheet, and will the system design actually be varying them at
> > runtime - if it will how will it do so?  This is the settings for the

> I am referring to the AB8500 device data sheet; not sure if its
> available open.  I have taken the minimal/maximum figures as what is
> mentioned for each supplies.

OK, you're missing the point here.  The system constraints say what's
going to be used on this actual system not what an individual component
is capable of supporting.  Regulators are almost always vastly more
flexible than any system can use and so the constraints are used to tell
the regulator core what configurations can be used on a given system.
You need to check what makes sense on the system for the things that are
connected.

> > Again, is it really the case that this will happen in this system?

> Yes, if you are referring to regulator enable/disable.

For *all* supplies?

> > Nothing is currently able to actually do that, and unless every consumer
> > using a given supply is hooked into the regulator API things will go
> > wrong when some of them start doing so.

> As i said earlier, my intention is to hard code the machine constraints.
> The actual control in terms of enable/disable, controlling supply
> voltages will happen, as you say when consumers are hooked up.

Again, you need to think about what's actually hooked up.  Permission to
do any of this stuff depends heavily on the set of consumers that are
actually hooked up - think about the example I mentioned above where
some of the consumers on a shared supply are hooked up and doing enables
and disables, for example.  What happens when they cause the supply to
be disabled but another consumer is running?
