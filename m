Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2CVDtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 23:49:13 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:42292
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab2CVDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 23:49:08 -0400
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371I146fK1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 22 Mar 2012 12:00:24 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "sjg@chromium.org" <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 5/6] dt: Document Tegra20/30 pinctrl binding
Message-ID: <20120322040024.GB840@shlinux2.ap.freescale.net>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
 <1332265479-1260-5-git-send-email-swarren@wwwdotorg.org>
 <20120321091919.GA18592@shlinux2.ap.freescale.net>
 <4F69FA5A.9020504@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F69FA5A.9020504@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:57:14PM +0800, Stephen Warren wrote:
> On 03/21/2012 03:19 AM, Dong Aisheng wrote:
> > On Wed, Mar 21, 2012 at 01:44:38AM +0800, Stephen Warren wrote:
> >> Define a new binding for the Tegra pin controller, which is capable of
> >> defining all aspects of desired pin multiplexing and pin configuration.
> >> This is all based on the new common pinctrl bindings.
> >>
> >> Add Tegra30 binding based on Tegra20 binding.
> >>
> >> Add some basic stuff that was missing before:
> >> * How many and what reg property entries must be provided.
> >> * An example.
> >>
> >> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> >> ---
> > ........
> >> +Example board file extract:
> >> +
> >> +	pinctrl@70000000 {
> >> +		sdio4_default {
> >> +			atb {
> >> +				nvidia,pins = "atb", "gma", "gme";
> >> +				nvidia,function = "sdio4";
> >> +				nvidia,pull = <0>;
> >> +				nvidia,tristate = <0>;
> >> +			};
> >> +		};
> >> +	};
> >> +
> >> +	sdhci@c8000600 {
> >> +		pinctrl-names = "default";
> >> +		pinctrl-0 = <&sdio4_default>;
> >
> > A typo error? sdio4_default is not a phandle.
> 
> Yes.
> 
> >> +Example board file extract:
> >> +
> >> +	pinctrl@70000000 {
> >> +		sdmmc4_default: pinmux {
> >> +			sdmmc4_clk_pcc4 {
> >> +				nvidia,pins =	"sdmmc4_clk_pcc4",
> >> +						"sdmmc4_rst_n_pcc3";
> >> +				nvidia,function = "sdmmc4";
> >> +				nvidia,pull = <0>;
> >> +				nvidia,tristate = <0>;
> >> +			};
> >> +			sdmmc4_dat0_paa0 {
> >> +				nvidia,pins =	"sdmmc4_dat0_paa0",
> >> +						"sdmmc4_dat1_paa1",
> >> +						"sdmmc4_dat2_paa2",
> >> +						"sdmmc4_dat3_paa3",
> >> +						"sdmmc4_dat4_paa4",
> >> +						"sdmmc4_dat5_paa5",
> >> +						"sdmmc4_dat6_paa6",
> >> +						"sdmmc4_dat7_paa7";
> >> +				nvidia,function = "sdmmc4";
> >> +				nvidia,pull = <2>;
> >> +				nvidia,tristate = <0>;
> >
> > It seems it does not support per pin config for tegra30 and we have to
> > separate them in different nodes with same group config value, right?
> 
> Sorry, I don't understand the question.
> 
I meant for tegra, the config(not mux) in one pinctrl node functions
on all entities in nvidia,pins, IOW, all pin or group must have the
same config.
So we can not set them differently in one node.

For example, considering if  sdmmc4_dat0_paa0 is nvidia,pull <0>
while sdmmc4_dat1_paa1 is nvidia,pull <1>.
Then we need to separate them in different pinctrl nodes, right?

I was thinking about whether we can use one pinctrl node to cover
all different group settings, however that may involve more complexity.
Anyway, it's driver specific part, i'm ok with what Tegra are doing.
It looks good to me right now.

> On Tegra30, pin mux selection and some pin configuration parameters are
> per-pin. Other pin configuration parameters are per-group. The pinctrl
> driver defines groups for:
> 
> * Each pin (for per-pin properties)
> * Each group that has non-per-pin configuration parameters.
> 
> You can use either/both sets of groups in the .dts file (i.e. in the
> nvidia,pins property).
> 
> You'd never end up with a single node that mixes the "per-pin" group
> names and "non-per-pin" group names, simply because there are no
> properties that can be applied to groups of both types in hardware.
> 

Regards
Dong Aisheng

