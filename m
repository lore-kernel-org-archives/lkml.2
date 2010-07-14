Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0GNO5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:57:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51883 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018Ab0GNO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:57:50 -0400
Date: Wed, 14 Jul 2010 15:57:48 +0100
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
Message-ID: <20100714145748.GF31073@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
 <20100713141828.GB24260@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B1810E7E88D@EXDCVYMBSTM006.EQ1STM.local>
 <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
 <20100713203852.GA1756@rakim.wolfsonmicro.main>
 <20100714145053.GA1689@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714145053.GA1689@bnru01.bnr.st.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 08:20:54PM +0530, Sundar R IYER wrote:

> > > +		.name = "ab8500-vaudio",
> > > +		.min_uV = 1925000,
> > > +		.max_uV = 2075000,

> > Are you *sure* that all these constraints are accurate for the board?

> As far as the min/max values of the voltage go, yes they are as per the
> data sheet.

Which datasheet, and will the system design actually be varying them at
runtime - if it will how will it do so?  This is the settings for the
particular system and generally a lot of these rails will get fixed at
design time for various reasons (for example, the analogue supplies will
usually depend on the analogue system design).

> > It seems every single voltage is variable even though there are no
> > consumers set up, and they can all be disabled too.

> Yes. all these regulators can be disabled/enabled. does this answer your
> qeury? ( or i didnt understand it properly??)

Again, is it really the case that this will happen in this system?
Nothing is currently able to actually do that, and unless every consumer
using a given supply is hooked into the regulator API things will go
wrong when some of them start doing so.
