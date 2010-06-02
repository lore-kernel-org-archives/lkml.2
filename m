Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0FBJaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:30:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37351 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0FBJ36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aFyJ92SHjENISiDQRTFbS6+/lvh/OGxP4py8dQqWBuf20Ot73MPeYtmaCUhEP4KUTs
         yM5sde4WN2WpyGgXWMjAB2TfXuugQ3osB3swBNv8XR2VCLxjiGQxWIxhfzSfMkfSbrpV
         HWKR+2G5MeThFbeU6wO9+5lpPOo4Dsu5kWMk8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
References: <1275468694.2545.1.camel@eight.analog.com>
	<AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
Date: Wed, 2 Jun 2010 17:29:55 +0800
Message-ID: <AANLkTincaxtwu_voxAbEkrOGeB5NWTVvmbHZJsaHpoYJ@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] regulator: new drivers for AD5398 
	and AD5821
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 5:02 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Jun 2, 2010 at 04:51, sonic zhang wrote:
>> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
>> sink capability. They feature an internal reference and operates from
>> a single 2.7 V to 5.5 V supply.
>>
>> This driver supports both the AD5398 and the AD5821.  It adapts into the
>> voltage and current framework.
>>
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> the "From:" doesnt match your s-o-b tag ...
>

Does this need to be matched? I prefer to discuss via gmail account
while keep company email in the patch owner information.

> also, this dropped my s-o-b:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
>> +config REGULATOR_AD5398
>> +       tristate "Ananlog Devices AD5398/AD5821 regulators"
>
> Analog
>
>> +       depends on I2C
>> +       help
>> +         This driver supports AD5398 and AD5821 current regulator chips.
>
> should mention the module name if built as a module
>
>> --- /dev/null
>> +++ b/drivers/regulator/ad5398.c
>> @@ -0,0 +1,285 @@
>> +/*
>> + * ad5398.c  --  Voltage and current regulation for AD5398 and AD5821
>
> dont think the filename needs to be here
>
>> + */
>> +#include <linux/module.h>
>
> should prob be a newline between these
>
>> +       /* write the new current value back as well as enable bit */
>> +       ret = ad5398_write_reg(client, (unsigned short)selector);
>
> the prototype of write_reg takes an unsigned short, so this cast is useless
>
>> +static struct regulator_ops ad5398_ops = {
>> +       .get_current_limit = ad5398_get_current_limit,
>> +       .set_current_limit = ad5398_set_current_limit,
>> +       .enable = ad5398_enable,
>> +       .disable = ad5398_disable,
>> +       .is_enabled = ad5398_is_enabled,
>> +};
>> +
>> +static struct regulator_desc ad5398_reg = {
>
> not specific to this driver, but it looks like regulator_ops and
> regulator_desc really should be constified
>
>> +static const struct ad5398_current_data_format ad5398_df = {10, 4};
>> +static const struct ad5398_current_data_format ad5821_df = {10, 4};
>> +
>> +static const struct i2c_device_id ad5398_id[] = {
>> +       { "ad5398", (kernel_ulong_t)&ad5398_df },
>> +       { "ad5821", (kernel_ulong_t)&ad5821_df },
>> +       { }
>> +};
>
> do you really need sep storage for these _df vars ?
>

Yes, this makes probe code simpler.

>> +static int ad5398_probe(struct i2c_client *client,
>> +static int ad5398_remove(struct i2c_client *client)
>> +       .remove = ad5398_remove,
>
> missing hotplug section markings
>
>> +       struct ad5398_current_data_format *df =
>> +                       (struct ad5398_current_data_format *)id->driver_data;
>
> this too should be const
>
>> +       chip = kzalloc(sizeof(struct ad5398_chip_info), GFP_KERNEL);
>
> sizeof(*chip)
>
>> +       dev_dbg(&client->dev, "%s regulator driver loaded\n", id->name);
>
> does the regulator core take care of displaying a notice ?  if not,
> i'd make this dev_info().  also, this should be "registered", not
> "loaded".
>

Mark prefers to have it printed only for debugging mode.

>> +MODULE_DESCRIPTION("AD5398 and AD5821 current regulator driver");
>> +MODULE_AUTHOR("Sonic Zhang");
>> +MODULE_LICENSE("GPL");
>
> should there be a MODULE_ALIAS() ?
> -mike
>
