Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0GNQUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:20:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53057 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757007Ab0GNQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:20:51 -0400
Date: Wed, 14 Jul 2010 17:20:49 +0100
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
Message-ID: <20100714162048.GA27512@rakim.wolfsonmicro.main>
References: <20100713145645.GA24626@rakim.wolfsonmicro.main>
 <20100713150814.GA13767@bnru01.bnr.st.com>
 <20100713150905.GD24626@rakim.wolfsonmicro.main>
 <20100713161343.GA25342@bnru01.bnr.st.com>
 <20100713203852.GA1756@rakim.wolfsonmicro.main>
 <20100714145053.GA1689@bnru01.bnr.st.com>
 <20100714145748.GF31073@rakim.wolfsonmicro.main>
 <20100714153643.GB1689@bnru01.bnr.st.com>
 <20100714154726.GH31073@rakim.wolfsonmicro.main>
 <20100714160941.GC1689@bnru01.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714160941.GC1689@bnru01.bnr.st.com>
X-Cookie: Too ripped.  Gotta go.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:39:42PM +0530, Sundar R IYER wrote:

> > For *all* supplies?

> Yes. whatever supplies I have listed here all can be enabled/disabled by
> their consumers. Sorry to ask, but please help me to understand the
> emphasis of the question. There are other supplies, which are controlled
> outside the kernel and so I haven't exposed them here.

Are you positive that in your system it is sensible for consumers to
enable and disable all the supplies?  Usually there are restrictions on
what can sensibly be done on a given system.  For example, disabling the
CPU core or RAM supplies from software would normally not work terribly
well.

> > some of the consumers on a shared supply are hooked up and doing enables
> > and disables, for example.  What happens when they cause the supply to
> > be disabled but another consumer is running?

> Again, sorry to ask(this is confusing :() - but isn't this managed by
> the core? It is the core's responsibility to effectively disable a
> supply when none of the consumers are using it; and to block a disable
> even when a single consumer is still using it.

Right, but think about the case I'm talking about: if you've only hooked
up some but not all of the consumers then the core has no idea about the
consumers you didn't hook up.  You can only do power control when *all*
the consumers needed are configured.
