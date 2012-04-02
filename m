Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2DBPsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:48:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36404 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2DBPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:48:35 -0400
Message-ID: <4F79CA4E.8040809@wwwdotorg.org>
Date: Mon, 02 Apr 2012 09:48:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linus.walleij@stericsson.com,
        B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 5/6] dt: Document Tegra20/30 pinctrl binding
References: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org>	<1332440842-1098-5-git-send-email-swarren@wwwdotorg.org> <CAPnjgZ0KhvPV8oO557i5czebm2J_KF7fmM3RDJoeYRurXu6Prg@mail.gmail.com>
In-Reply-To: <CAPnjgZ0KhvPV8oO557i5czebm2J_KF7fmM3RDJoeYRurXu6Prg@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:49 AM, Simon Glass wrote:
> Hi Stephen,
> 
> On Thu, Mar 22, 2012 at 11:27 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
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
>> v3: Fix typo in Tegra20 binding example
...
>> +Example board file extract:
>> +
>> +       pinctrl@70000000 {
>> +               sdmmc4_default: pinmux {
>> +                       sdmmc4_clk_pcc4 {
>> +                               nvidia,pins =   "sdmmc4_clk_pcc4",
>> +                                               "sdmmc4_rst_n_pcc3";
>> +                               nvidia,function = "sdmmc4";
>> +                               nvidia,pull = <0>;
>> +                               nvidia,tristate = <0>;
>> +                       };
>> +                       sdmmc4_dat0_paa0 {
>> +                               nvidia,pins =   "sdmmc4_dat0_paa0",
>> +                                               "sdmmc4_dat1_paa1",
>> +                                               "sdmmc4_dat2_paa2",
>> +                                               "sdmmc4_dat3_paa3",
>> +                                               "sdmmc4_dat4_paa4",
>> +                                               "sdmmc4_dat5_paa5",
>> +                                               "sdmmc4_dat6_paa6",
>> +                                               "sdmmc4_dat7_paa7";
> 
> I see that you have done with a hierarchical approach which I like a lot.
> 
> However, the large number of strings here (using a string to name a
> function and a pin) is going to create quite a bit of overhead, not to
> mention FDT space.

IIRC, I profiled this in the middle of last year and while there was
measurable overhead using strings relative to integers, it was tiny; on
the order of perhaps a couple mS.

> Have you given up on the /define/ patch that you created?

Not entirely, but it's obvious it will take a /long/ time to get that or
equivalent functionality into dtc. I'd rather not block pinmux-in-dtc by
waiting for it, especially when the string alternative works fine with
what I consider reasonable overhead.

> If so, I wonder if we could at least provide an alternate binding
> using numbering.

I'd rather only have a single binding; alternatives are just going to
add a bunch of complexity.

Perhaps we can have a flag-day in the future and change the binding once
dtc has grown named-constants support or we've got cpp integrated into
the build flow for this.

> I have just figured out how to get the C preprocessor
> out of U-Boot's FDT path,

I don't understand exactly what that means.

> but if that is the only way, perhaps the
> kernel should use that to get numbered symbols?
> 
> I would much prefer a parallel property which provides the names, that
> can be omitted.

If we did have multiple possible data representations, either-or seems
better; allowing both to co-exist just opens up the potential for them
to say different things.

> (Similarly for your 'nvidia,pull' property, it would be nice to have a
> symbolic name)
> 
>> +                               nvidia,function = "sdmmc4";
>> +                               nvidia,pull = <2>;
>> +                               nvidia,tristate = <0>;
>> +                       };
>> +               };
>> +       };
>> +
>> +       sdhci@78000400 {
>> +               pinctrl-names = "default";
>> +               pinctrl-0 = <&sdmmc4_default>;
>> +       };
