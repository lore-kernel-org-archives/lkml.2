Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2IGVNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:13:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40810 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGVNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120906185937.GY1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
	<1346835718-21325-2-git-send-email-peter.ujfalusi@ti.com>
	<20120906185937.GY1303@atomide.com>
Date: Fri, 7 Sep 2012 23:13:02 +0200
Message-ID: <CACRpkdY8PLQxP85hBo4-s8hYGxQH_hKD_YwzBc6m4gnkGBknmQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-single: Make sure we do not change
 bits outside of mask
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 8:59 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [120905 02:02]:
>> Use the pcs->fmask to make sure that the value is not changing (setting)
>> bits in areas where it should not.
>> To avoid situations like this:
>>
>> pmx_dummy: pinmux@4a100040 {
>>       compatible = "pinctrl-single";
>>       reg = <0x4a100040 0x0196>;
>>       #address-cells = <1>;
>>       #size-cells = <0>;
>>       pinctrl-single,register-width = <16>;
>>       pinctrl-single,function-mask = <0x00ff>;
>> };
>>
>> &pmx_dummy {
>>       pinctrl-names = "default";
>>       pinctrl-0 = <&board_pins>;
>>
>>       board_pins: pinmux_board_pins {
>>               pinctrl-single,pins = <
>>                       0x6c 0xf0f
>>                       0x6e 0x10f
>>                       0x70 0x23f
>>                       0x72 0xa5f
>>               >;
>>       };
>> };
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>
> Thanks this is a valid fix:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

Since nothing in v3.6 is using pinctrl-simple yet, it's not a regression
right?

So can you just group this with the other pinctrl things you are
harvesting in the OMAP tree? I was going to push it for
the v3.7 cycle otherwise.

Yours,
Linus Walleij
