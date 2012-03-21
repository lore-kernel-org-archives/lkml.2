Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2CUP53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:57:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58684 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2CUP5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:57:24 -0400
Message-ID: <4F69FA5A.9020504@wwwdotorg.org>
Date: Wed, 21 Mar 2012 09:57:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
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
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org> <1332265479-1260-5-git-send-email-swarren@wwwdotorg.org> <20120321091919.GA18592@shlinux2.ap.freescale.net>
In-Reply-To: <20120321091919.GA18592@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 03:19 AM, Dong Aisheng wrote:
> On Wed, Mar 21, 2012 at 01:44:38AM +0800, Stephen Warren wrote:
>> Define a new binding for the Tegra pin controller, which is capable of
>> defining all aspects of desired pin multiplexing and pin configuration.
>> This is all based on the new common pinctrl bindings.
>>
>> Add Tegra30 binding based on Tegra20 binding.
>>
>> Add some basic stuff that was missing before:
>> * How many and what reg property entries must be provided.
>> * An example.
>>
>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>> ---
> ........
>> +Example board file extract:
>> +
>> +	pinctrl@70000000 {
>> +		sdio4_default {
>> +			atb {
>> +				nvidia,pins = "atb", "gma", "gme";
>> +				nvidia,function = "sdio4";
>> +				nvidia,pull = <0>;
>> +				nvidia,tristate = <0>;
>> +			};
>> +		};
>> +	};
>> +
>> +	sdhci@c8000600 {
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&sdio4_default>;
>
> A typo error? sdio4_default is not a phandle.

Yes.

>> +Example board file extract:
>> +
>> +	pinctrl@70000000 {
>> +		sdmmc4_default: pinmux {
>> +			sdmmc4_clk_pcc4 {
>> +				nvidia,pins =	"sdmmc4_clk_pcc4",
>> +						"sdmmc4_rst_n_pcc3";
>> +				nvidia,function = "sdmmc4";
>> +				nvidia,pull = <0>;
>> +				nvidia,tristate = <0>;
>> +			};
>> +			sdmmc4_dat0_paa0 {
>> +				nvidia,pins =	"sdmmc4_dat0_paa0",
>> +						"sdmmc4_dat1_paa1",
>> +						"sdmmc4_dat2_paa2",
>> +						"sdmmc4_dat3_paa3",
>> +						"sdmmc4_dat4_paa4",
>> +						"sdmmc4_dat5_paa5",
>> +						"sdmmc4_dat6_paa6",
>> +						"sdmmc4_dat7_paa7";
>> +				nvidia,function = "sdmmc4";
>> +				nvidia,pull = <2>;
>> +				nvidia,tristate = <0>;
>
> It seems it does not support per pin config for tegra30 and we have to
> separate them in different nodes with same group config value, right?

Sorry, I don't understand the question.

On Tegra30, pin mux selection and some pin configuration parameters are
per-pin. Other pin configuration parameters are per-group. The pinctrl
driver defines groups for:

* Each pin (for per-pin properties)
* Each group that has non-per-pin configuration parameters.

You can use either/both sets of groups in the .dts file (i.e. in the
nvidia,pins property).

You'd never end up with a single node that mixes the "per-pin" group
names and "non-per-pin" group names, simply because there are no
properties that can be applied to groups of both types in hardware.
