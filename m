Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab2D0IpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:45:25 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:49130
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759895Ab2D0IpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:45:18 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 16:54:46 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Zhao Richard-B20223 <B20223@freescale.com>
Subject: Re: [PATCH v3 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl
 subsystem
Message-ID: <20120427085445.GE826@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-4-git-send-email-b29396@freescale.com>
 <20120427073504.GS17184@pengutronix.de>
 <20120427082930.GC826@shlinux2.ap.freescale.net>
 <20120427083142.GY17184@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120427083142.GY17184@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:31:42PM +0800, Sascha Hauer wrote:
> On Fri, Apr 27, 2012 at 04:29:31PM +0800, Dong Aisheng wrote:
> > mach-imx27ipcam.c          mach-mx31ads.c             mach-mx51_babbage.o        mach-pca100.c
> > mach-imx27lite.c           mach-mx31ads.o             mach-mx51_efikamx.c        mach-pcm037.c
> > 
> > Some of them i'm not familiar and i don't know whether they may use pinctrl
> > so i just patched the affected ones.
> > 
> > One lazy method may be just patch all board files without pinctrl support
> > and it will not cause any error.
> > 
> > What's your suggestion?
> > 
> > > pinctrl. Let's add the provide_dummies call to the SoCs instead which
> > > do not have pinctrl yet.
> > > 
> > You meant add provide_dummies call in imx*_soc_init call?
> > We could do it but there might be a case that some boards are converted
> > to use pinctrl while others still not but they're based on the same soc.
> > For examples, 4 mx53 boards and we may not be able to convert them all at
> > the same time.
> 
> My point is that none of the mx5 boards have pinctrl since there is no
> SoC driver for it.
> For DT based boards pinctrl should be mandatory once the SoC has pinctrl
> support. All non DT boards probably won't get pinctrl anyway.
> 
Ok, so i would be fine for me to change it in imx*_soc_init.
BTW, there're:
imx1_soc_init()
imx25_soc_init()
imx27_soc_init()
imx31_soc_init()
imx35_soc_init()
imx50_soc_init()
imx51_soc_init()
imx53_soc_init()

I'm not sure about mx1, mx27, mx31
Do you think if i could add them all?

Regards
Dong Aisheng

