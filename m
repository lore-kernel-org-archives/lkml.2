Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2FSH6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:58:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39229 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FSH6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:58:23 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FB8C8@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB8C8@DQHE02.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 19 Jun 2012 15:58:02 +0800
Message-ID: <CAF+7xWmNOFaYhLRxDa5z62W1pWvUt460cNSTJpaxZ6C+-9azwg@mail.gmail.com>
Subject: Re: [PATCH v3] regulator: add new regulator driver for lp872x
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/19 Kim, Milo <Milo.Kim@ti.com>:
> This driver supports TI/National LP8720, LP8725 PMIC.
>
You might want to add more commit description here.
e.g. ( I just copy-paste from your first version.)

This driver supports TI/National Semiconductor LP8720 and LP8725 PMU.
LP8720 : 5 LDOs and 1 BUCK
LP8725 : 7 LDOs and 2 BUCKS
These ICs have similar register map for controlling regulators.

Datasheet
---------
LP8720 : http://www.ti.com/litv/pdf/snvs575a
LP8725 : http://www.ti.com/lit/gpn/lp8725
I2C compatible interface
------------------------
The regmap APIs are used for accessing the registers
Supported regulator operations
------------------------------
* list_voltage/set_voltage_sel/get_voltage_sel
  : voltage tables are used for selecting specific voltage
* enable/disable/is_enabled/enable_time
* set_mode/get_mode
  : BUCK specific operations. Forced pwm and normal mode are selective
* set_current_limit/get_current_limit
  : current limit operations for lp8725 BUCKs
Platform data
-------------
3 mandatory and 1 optional data are defined.
* general_config : value of GENERAL_CFG register is platform specific data
* regulator_data : regulator init data with id in platform side
* num_regulators : numbers of regulator_data
* get_dvs_pin_state : used for selecting buck output register
    DVS input is platform specific pin for choosing buck register address

Below description should be put under --- line, so it won't display in
commit log.

> patch v3
>
> (a) replace few if-statements with switch-statements
> (b) use devm_gpio_request_one() for configuring dvs gpio
> : replace gpio_request() and gpio_direction_output() with devm_gpio_request_one()
>  remove gpio_free() code
>
> (c) enhanced code on finding matched regulator init data
> : change max loop count. fixed loop count (9) -> variable count (6 or 9)
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

The code looks good to me,
Reviewed-by: Axel Lin <axel.lin@gmail.com>

Regards,
Axel
