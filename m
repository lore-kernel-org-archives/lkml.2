Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2FMLls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:41:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58912 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2FMLlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:41:47 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120613100342.GI4545@opensource.wolfsonmicro.com>
References: <1339467650.22991.1.camel@phoenix> <1339467789.22991.4.camel@phoenix>
 <20120613100342.GI4545@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 13 Jun 2012 19:41:26 +0800
Message-ID: <CAF+7xWnQNGL8Q0mCLMTHrUnW-cbOuNLydFW+b6Nws_Pg-ePUJg@mail.gmail.com>
Subject: Re: [PATCH RFT 3/4] regulator: wm831x-dcdc: Convert wm831x_buckv_ops
 to set_voltage_sel and map_voltage
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Jun 12, 2012 at 10:23:09AM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> This patch is way more invasive than it needs to be (and therefore hard
> to check) because
>
>> -     if (dcdc->dvs_gpio && dcdc->on_vsel == vsel)
>> +     if (dcdc->dvs_gpio && dcdc->on_vsel == selector)
>
> you've replaced vsel with selector throughout the code.

Sorry. I don't get it.

In wm831x_buckv_set_voltage(), we call
wm831x_buckv_select_min_voltage() to get the selector ( named vsel).

In this patch, now we convert to set_voltage_sel:

static int wm831x_buckv_set_voltage_sel(struct regulator_dev *rdev,
                                        unsigned selector)

So the selector now named 'selector'.


Or do you prefer I chenge the prototype to:

static int wm831x_buckv_set_voltage_sel(struct regulator_dev *rdev,
                                        unsigned vsel)

Then the diff can be smaller.

Regards,
Axel
