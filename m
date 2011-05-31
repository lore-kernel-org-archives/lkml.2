Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1EaPFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:05:32 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7326
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab1EaPF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:05:29 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 31 May 2011 23:10:20 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Message-ID: <20110531151019.GA32275@S2100-06.ap.freescale.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <201105311026.11947.arnd@arndb.de>
 <20110531103011.GB32096@S2100-06.ap.freescale.net>
 <201105311328.18012.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201105311328.18012.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 01:28:17PM +0200, Arnd Bergmann wrote:
> On Tuesday 31 May 2011, Shawn Guo wrote:
> > > Just open-code the mxc_add_mxc_gpio() by moving the individual calls to
> > > mxc_add_gpio() into the respective callers. Having a global
> > > mxc_add_mxc_gpio() function that does something different for each
> > > caller seems entirely pointless to me.
> > > 
> > Right now, mxc_add_mxc_gpio() is a postcore_initcall.  Moving
> > individual mxc_add_gpio() call into irq_init function does not work.
> > And I need to find a proper caller for each SoC to call mxc_add_gpio
> > to register gpio devices.
>  
> Why not init_machine? That is an arch_initcall(), so it's probably close
> enough.
> 
The init_machine is mostly a board specific function than SoC specific
one.  That is to say we will call mxc_add_gpio() in every single board
init function even for the same SoC.

-- 
Regards,
Shawn

