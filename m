Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2CWEkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:40:31 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:6728
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab2CWEk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:40:27 -0400
X-SpamScore: -20
X-BigFish: VS-20(zzbb2dI9371I146fK179dN1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 23 Mar 2012 12:51:41 +0800
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
Message-ID: <20120323045140.GA23962@shlinux2.ap.freescale.net>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
 <1332265479-1260-5-git-send-email-swarren@wwwdotorg.org>
 <20120321091919.GA18592@shlinux2.ap.freescale.net>
 <4F69FA5A.9020504@wwwdotorg.org>
 <20120322040024.GB840@shlinux2.ap.freescale.net>
 <4F6B491B.8040506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F6B491B.8040506@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 11:45:31PM +0800, Stephen Warren wrote:
> On 03/21/2012 10:00 PM, Dong Aisheng wrote:
> > On Wed, Mar 21, 2012 at 11:57:14PM +0800, Stephen Warren wrote:
> >> On 03/21/2012 03:19 AM, Dong Aisheng wrote:
> >>> On Wed, Mar 21, 2012 at 01:44:38AM +0800, Stephen Warren wrote:
> >>>> Define a new binding for the Tegra pin controller, which is capable of
> >>>> defining all aspects of desired pin multiplexing and pin configuration.
> >>>> This is all based on the new common pinctrl bindings.
> >>>>
> >>>> Add Tegra30 binding based on Tegra20 binding.
> ...
> >>>> +Example board file extract:
> >>>> +
> >>>> +	pinctrl@70000000 {
> >>>> +		sdmmc4_default: pinmux {
> >>>> +			sdmmc4_clk_pcc4 {
> >>>> +				nvidia,pins =	"sdmmc4_clk_pcc4",
> >>>> +						"sdmmc4_rst_n_pcc3";
> >>>> +				nvidia,function = "sdmmc4";
> >>>> +				nvidia,pull = <0>;
> >>>> +				nvidia,tristate = <0>;
> >>>> +			};
> >>>> +			sdmmc4_dat0_paa0 {
> >>>> +				nvidia,pins =	"sdmmc4_dat0_paa0",
> >>>> +						"sdmmc4_dat1_paa1",
> >>>> +						"sdmmc4_dat2_paa2",
> >>>> +						"sdmmc4_dat3_paa3",
> >>>> +						"sdmmc4_dat4_paa4",
> >>>> +						"sdmmc4_dat5_paa5",
> >>>> +						"sdmmc4_dat6_paa6",
> >>>> +						"sdmmc4_dat7_paa7";
> >>>> +				nvidia,function = "sdmmc4";
> >>>> +				nvidia,pull = <2>;
> >>>> +				nvidia,tristate = <0>;
> >>>
> >>> It seems it does not support per pin config for tegra30 and we have to
> >>> separate them in different nodes with same group config value, right?
> >>
> >> Sorry, I don't understand the question.
> >
> > I meant for tegra, the config(not mux) in one pinctrl node functions
> > on all entities in nvidia,pins, IOW, all pin or group must have the
> > same config.
> > So we can not set them differently in one node.
> > 
> > For example, considering if  sdmmc4_dat0_paa0 is nvidia,pull <0>
> > while sdmmc4_dat1_paa1 is nvidia,pull <1>.
> > Then we need to separate them in different pinctrl nodes, right?
> 
> Yes, that's true.
> 
> However, note that you can have more than one node affecting a
> particular pin or group if you want. For example, you could have one set
> of nodes that sets the mux, another set of nodes that sets
> pullup/down/none, another set that sets tristate/driven. That way,
> within each set of nodes, you get to group together all pins with
> similar properties. This is all because we take the list of affected
> pins/groups from the nvidia,pins property, rather than e.g. the node
> name, so it's possible to list the same pin/group in multiple nodes. An
> example from the Tegra Harmony board file:
> 
> There's one node for each mux function that's used, specifying which
> pins/groups it's used on:
> 
>     ata {
>             pins = "ata";
>             function = "ide";
>     };
>     atb {
>             nvidia,pins = "atb", "gma", "gme";
>             nvidia,function = "sdio4";
>     };
>     ... many other nodes for other functions
> 
> There's also one node for each combination of pull and tristate that's
> used, specifying which pins/groups it's used on:
> 
>     conf_ata {
>             nvidia,pins = "ata", "atb", "atc", "atd", "ate",
>                     "cdev1", "dap1", "dtb", "gma", "gmb",
>                     "gmc", "gmd", "gme", "gpu7", "gpv",
>                     "i2cp", "pta", "rm", "slxa", "slxk",
>                     "spia", "spib";
>             nvidia,pull = <0>;
>             nvidia,tristate = <0>;
>     };
>     ... many other nodes for other pull/tristate combinations
> 
> I ran a script to group the various pins into nodes in different ways,
> and this particular combination seemed to generate the smallest device
> tree source file for Harmony.
> 

Hmm, either is ok to me. this way may save some properties and nodes.
But i still prefer to do pin mux and config at the same place as you did
in the binding doc like:
sdmmc4_clk_pcc4 {
	nvidia,pins =	"sdmmc4_clk_pcc4",
			"sdmmc4_rst_n_pcc3";
	nvidia,function = "sdmmc4";
	nvidia,pull = <0>;
	nvidia,tristate = <0>;
};
It's very easy to read and control.
Anyway, this is question how to write dts rather than the patch itself.
This patch is ok to me.

Regards
Dong Aisheng

