Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1EaKZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:25:23 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:8701
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859Ab1EaKZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:25:22 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 31 May 2011 18:30:12 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Message-ID: <20110531103011.GB32096@S2100-06.ap.freescale.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <20110531001634.GB3411@quad.lixom.net>
 <20110531024729.GB31928@S2100-06.ap.freescale.net>
 <201105311026.11947.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105311026.11947.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:26:11AM +0200, Arnd Bergmann wrote:
> On Tuesday 31 May 2011, Shawn Guo wrote:
> > > The above tables are pretty crazy, and they only get worse later in the series
> > > when the other SoCs are added. Is it really worth it to have a common initcall
> > > entry for the various SoCs here?
> > > 
> > This common initcall seems a good place to concentrate the gpio device
> > registration.  It's easy to look at the common/different things among
> > these SoCs.  The only problem you reminded me is the scanning of the
> > long cpu_is_mx list.  It can be optimized a little bit by sorting the
> > list from the latest (most used) SoC to the oldest (least used) one,
> > and breaking out the scanning immediately when hitting one.
> 
> No, better make them separate functions.
> 
> > > It'd seem cleaner to me to just call the registration function for the
> > > family you're running from in per-family-init code such as where it was
> > > removed above (irq init, which makes some sense since the gpios provide
> > > interrupt sources as well).
> > > 
> > I just gave it a test, and it's not working at all.  (too early
> > to register device in irq init?)
> 
> Just open-code the mxc_add_mxc_gpio() by moving the individual calls to
> mxc_add_gpio() into the respective callers. Having a global
> mxc_add_mxc_gpio() function that does something different for each
> caller seems entirely pointless to me.
> 
Right now, mxc_add_mxc_gpio() is a postcore_initcall.  Moving
individual mxc_add_gpio() call into irq_init function does not work.
And I need to find a proper caller for each SoC to call mxc_add_gpio
to register gpio devices.

-- 
Regards,
Shawn

