Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2IBNNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:13:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34176 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab2IBNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY3atmx4N-Zq2imrgPoukueYiexzndD7bVyQTgV02Vpuw@mail.gmail.com>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
	<CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
	<CACRpkdY3atmx4N-Zq2imrgPoukueYiexzndD7bVyQTgV02Vpuw@mail.gmail.com>
Date: Sun, 2 Sep 2012 18:42:49 +0530
Message-ID: <CAPub14891Bhdt=KNz8SZLS6Ps2snhy9LgOU=yGGMrntcK9xxRA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] spi/pl022: Add chip select handling via GPIO
From: shiraz hashim <shiraz.linux.kernel@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roland Stigge <stigge@antcom.de>, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Sep 2, 2012 at 12:48 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Sep 1, 2012 at 1:14 PM, shiraz hashim
> <shiraz.linux.kernel@gmail.com> wrote:
>> Hi Roland,
>>
>> On Wed, Aug 22, 2012 at 7:19 PM, Roland Stigge <stigge@antcom.de> wrote:
>>> @@ -2016,6 +2030,8 @@ pl022_probe(struct amba_device *adev, co
>>>         pl022->master_info = platform_info;
>>>         pl022->adev = adev;
>>>         pl022->vendor = id->data;
>>> +       /* Point chipselects to allocated memory beyond the main struct */
>>> +       pl022->chipselects = (int *) pl022 + sizeof(struct pl022);
>>
>> This is going beyond memory allocated for chipselects
>> as it adds 4 * sizeof(struct pl022) bytes to pl022.
>
> Yes that is why the allocation looks like this:
>
> +       master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
> +                                 platform_info->num_chipselect);
>

The allocation is such because type of chipselects is int.

The statement for allocation is correct, but

       pl022->chipselects = (int *) pl022 + sizeof(struct pl022);

is not adding  sizeof(struct pl022) bytes to pl022 base (which we want),
but infact 4 times the size of pl022 (because type of pl022 is now int *).

Do you get my point ?  This would go way beyond memory allocated
for chipselects.

-- 
regards
Shiraz Hashim
