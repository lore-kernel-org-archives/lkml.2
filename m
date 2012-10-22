Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2JVI1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:27:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49921 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2JVI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:27:09 -0400
Message-ID: <50850352.7020000@ti.com>
Date: Mon, 22 Oct 2012 10:26:58 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sourav <sourav.poddar@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] arm: dts: omap4-sdp: pinmux configuration for keypad
References: <1350890955-29553-1-git-send-email-sourav.poddar@ti.com> <5084F99B.1030709@ti.com> <50850299.7070405@ti.com>
In-Reply-To: <50850299.7070405@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 10:23 AM, Sourav wrote:
> Hi Benoit,
> On Monday 22 October 2012 01:15 PM, Benoit Cousson wrote:
>> Hi Sourav,
>>
>> On 10/22/2012 09:29 AM, Sourav Poddar wrote:
>>> Currently, omap4 keypad mux settings are done in the board file.
>>> Populate the mux settings in the dts file for the keypad to
>>> work via dt.
>> Have you changed the driver to handle properly the dependency with the
>> pinctrl and thus return EPROBE_DEFER if this is not ready?
> I have send a patch[1] to the mailing list on the driver changes.
> http://www.spinics.net/lists/linux-omap/msg79985.html.

Yeah, sorry, I've just seen it :-(.

> Though, I see I have missed the following EPROBE_DEFER check..

Yes, indeed.

> +               if (PTR_ERR(dev->pins) == -EPROBE_DEFER)
> +                       return -EPROBE_DEFER;
> Will add for the above patch.

Thanks,
Benoit

>> Seb Guiriec has just sent a patch to do that for the omap-i2c driver
>> ([PATCH] i2c: omap: adopt pinctrl support).
>>
>>> Cc: Felipe Balbi <balbi@ti.com>
>>> Tested on omap4430 sdp with 3.7-rc1.
>>>
>>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>>> ---
>>>   arch/arm/boot/dts/omap4-sdp.dts |   26 ++++++++++++++++++++++++++
>>>   1 files changed, 26 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap4-sdp.dts
>>> b/arch/arm/boot/dts/omap4-sdp.dts
>>> index 5b7e04f..5efb059 100644
>>> --- a/arch/arm/boot/dts/omap4-sdp.dts
>>> +++ b/arch/arm/boot/dts/omap4-sdp.dts
>>> @@ -194,6 +194,27 @@
>>>               0xbc 0x100    /* abe_mcbsp2_fsx.abe_mcbsp2_fsx INPUT |
>>> MODE0 */
>>>           >;
>>>       };
>>> +
>>> +    keypad_pins: pinmux_keypad_pins {
>>> +        pinctrl-single,pins = <
>>> +            0x24 0x4119   /* gpmc_a18.kpd_row6 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x26 0x4119   /* gpmc_a19.kpd_row6 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x2c 0x4001   /* gpmc_a22.kpd_col6 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x2e 0x4001   /* gpmc_a23.kpd_col7 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x13c 0x4001  /* kpd_col0.kpd_col0 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x13e 0x4001  /* kpd_col1.kpd_col1 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x140 0x4001  /* kpd_col2.kpd_col2 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x142 0x10F   /* kpd_col3.kpd_col3 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>> Alway use lower case for hexa value.
> Ok. Will fix and send a new version.
>>> +            0x144 0x4001  /* kpd_col4.kpd_col4 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x146 0x4001  /* kpd_col5.kpd_col5 OMAP_WAKEUP_EN |
>>> OMAP_MUX_MODE1 */
>>> +            0x148 0xc119  /* kpd_row0.kpd_row0 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x14a 0x4119  /* kpd_row1.kpd_row1 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x14c 0x4119  /* kpd_row2.kpd_row2 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x14e 0x4119  /* kpd_row3.kpd_row3 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x150 0x4119  /* kpd_row4.kpd_row4 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +            0x152 0x4119  /* kpd_row5.kpd_row5 OMAP_PULL_ENA |
>>> OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
>>> +        >;
>>> +    };
>>>   };
>>>     &i2c1 {
>>> @@ -406,3 +427,8 @@
>>>   &mcbsp3 {
>>>       status = "disabled";
>>>   };
>>> +
>>> +&keypad {
>>> +        pinctrl-names = "default";
>>> +        pinctrl-0 = <&keypad_pins>;
>>> +};
>> Otherwise that looks good.
>>
>> Thanks,
>> Benoit
> Thanks,
> Sourav

