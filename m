Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0FBKKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:10:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33878 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0FBKKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jN52FDxWfrgnl7VGDd4ySGrKnJEx0lm+Y1cTxlsXuMj+JuEBIErs3gkiXxYlLipkaY
         wlIip7s1b4cqyihsFeCdF253KHLbI2QjFi3GIM4Wbrl4SHXvg0q2dZuk7EIYQBKz4ov2
         LikMUTq0T4dI4H5g32tex6P3LWfhwM8+7tV4Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTilIweGx1NXLiTuRphex1RMk9DF3Vdva5F-6JDKl@mail.gmail.com>
References: <1275468694.2545.1.camel@eight.analog.com>
	<AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
	<AANLkTincaxtwu_voxAbEkrOGeB5NWTVvmbHZJsaHpoYJ@mail.gmail.com>
	<AANLkTilIweGx1NXLiTuRphex1RMk9DF3Vdva5F-6JDKl@mail.gmail.com>
Date: Wed, 2 Jun 2010 18:10:19 +0800
Message-ID: <AANLkTilZ5jJo8spBdfXBqZmTRfNlq4PQJI5wsn2lBj9Z@mail.gmail.com>
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

On Wed, Jun 2, 2010 at 5:36 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Jun 2, 2010 at 05:29, Sonic Zhang wrote:
>> On Wed, Jun 2, 2010 at 5:02 PM, Mike Frysinger wrote:
>>> On Wed, Jun 2, 2010 at 04:51, sonic zhang wrote:
>>>> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
>>>> sink capability. They feature an internal reference and operates from
>>>> a single 2.7 V to 5.5 V supply.
>>>>
>>>> This driver supports both the AD5398 and the AD5821.  It adapts into the
>>>> voltage and current framework.
>>>>
>>>>
>>>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>> the "From:" doesnt match your s-o-b tag ...
>>
>> Does this need to be matched? I prefer to discuss via gmail account
>> while keep company email in the patch owner information.
>
> so set the From: in the body as the first line like git-send-email does it:
> From: <author info>
>
> <commit message>
>
> <other tags>
> ---
>  <diffstat>
> ..........
>
>>>> +static const struct ad5398_current_data_format ad5398_df = {10, 4};
>>>> +static const struct ad5398_current_data_format ad5821_df = {10, 4};
>>>> +
>>>> +static const struct i2c_device_id ad5398_id[] = {
>>>> +       { "ad5398", (kernel_ulong_t)&ad5398_df },
>>>> +       { "ad5821", (kernel_ulong_t)&ad5821_df },
>>>> +       { }
>>>> +};
>>>
>>> do you really need sep storage for these _df vars ?
>>
>> Yes, this makes probe code simpler.
>
> how does it make any difference to the probe code what each id is
> pointing to ?  it isnt comparing the private data pointers to any
> other storage pointers.
>
> from what i can see, this should give the same exact behavior:
> static const struct ad5398_current_data_format df_10_4 = {10, 4};
> static const struct i2c_device_id ad5398_id[] = {
>       { "ad5398", (kernel_ulong_t)&df_10_4 },
>       { "ad5821", (kernel_ulong_t)&df_10_4 },
> -mike
>

Yes, the behavior is the same for ad5398 and ad5821. But, if more
chips are enabled in this driver, they may differ.
This line is used as an example for future chips.

Sonic
