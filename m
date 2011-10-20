Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1JTCfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:35:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:8309 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1JTCfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:35:08 -0400
X-SpamScore: -8
X-BigFish: VS-8(z1039oz179dN1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Thu, 20 Oct 2011 10:45:56 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
Message-ID: <20111020024556.GD32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 04:04:29PM -0700, Stephen Warren wrote:
> > @@ -113,6 +204,10 @@ extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
> ...
> > +extern int pin_config(struct pinctrl_dev *pctldev, int pin,
> > +		      enum pin_config_param param, unsigned long data);
> > +extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
> > +			    enum pin_config_param param, unsigned long data);
> 
> Hmmm. Do we really want to expose these as public APIs? I suppose it
> will allow us to start configuring all these parameters ASAP, but all
> previous discussion has been aimed at having the pinctrl core set up an
> initial set of values at boot-time using a board-supplied table (so no
> external API), and then we were still talking about how to manipulate
> the values at run-time. Do we really want to encode all this information
> into drivers calling these APIs?
> 
+1

We should not require device driver to call these APIs directly.  There
are so many pinctrl subsystem internal details left to its users.

The Stephen's proposal [1] about adding a new param into pinmux_enable()
to specify pin configuration is much preferred to me.

Regards,
Shawn

[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/137341

