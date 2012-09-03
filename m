Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2ICJKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:10:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48968 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2ICJKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAPub14891Bhdt=KNz8SZLS6Ps2snhy9LgOU=yGGMrntcK9xxRA@mail.gmail.com>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
	<CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
	<CACRpkdY3atmx4N-Zq2imrgPoukueYiexzndD7bVyQTgV02Vpuw@mail.gmail.com>
	<CAPub14891Bhdt=KNz8SZLS6Ps2snhy9LgOU=yGGMrntcK9xxRA@mail.gmail.com>
Date: Mon, 3 Sep 2012 11:10:28 +0200
Message-ID: <CACRpkdY2_nSUvyhXGwzYcLqVuS+ryuyVbKKmD+yHdxCwYLhdMA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] spi/pl022: Add chip select handling via GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: shiraz hashim <shiraz.linux.kernel@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 3:12 PM, shiraz hashim
<shiraz.linux.kernel@gmail.com> wrote:
> Hi Linus,

>> Yes that is why the allocation looks like this:
>>
>> +       master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
>> +                                 platform_info->num_chipselect);
>>
>
> The allocation is such because type of chipselects is int.
>
> The statement for allocation is correct, but
>
>        pl022->chipselects = (int *) pl022 + sizeof(struct pl022);
>
> is not adding  sizeof(struct pl022) bytes to pl022 base (which we want),
> but infact 4 times the size of pl022 (because type of pl022 is now int *).
>
> Do you get my point ?  This would go way beyond memory allocated
> for chipselects.

Yes of course ... how could I not see this. Sorry!

Yours,
Linus Walleij
