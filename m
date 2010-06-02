Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0FBKTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:19:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0FBKTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XDxHOpCfxXtJFi62+FuIptVsSjRk8BZmD+AWP+rKTMmVeRZW7ukJfzuio+tuqC7UvK
         QeDSAmR/Cn7AVjS6nwag/SZSBYuWtwlq1zYOqig7HJyva2lno46ZW1uSOavCTBVvYiUs
         yxZI6u71d2/5gKRTPHQuvg/r5fFyh4DOF57jM=
MIME-Version: 1.0
In-Reply-To: <AANLkTilZ5jJo8spBdfXBqZmTRfNlq4PQJI5wsn2lBj9Z@mail.gmail.com>
References: <1275468694.2545.1.camel@eight.analog.com> <AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com> 
	<AANLkTincaxtwu_voxAbEkrOGeB5NWTVvmbHZJsaHpoYJ@mail.gmail.com> 
	<AANLkTilIweGx1NXLiTuRphex1RMk9DF3Vdva5F-6JDKl@mail.gmail.com> 
	<AANLkTilZ5jJo8spBdfXBqZmTRfNlq4PQJI5wsn2lBj9Z@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Jun 2010 06:18:57 -0400
Message-ID: <AANLkTikLZjLaHSYJ5Z6q8fAxrmTsmnjaUjqlIDPgnz84@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] regulator: new drivers for AD5398 
	and AD5821
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 06:10, Sonic Zhang wrote:
> On Wed, Jun 2, 2010 at 5:36 PM, Mike Frysinger wrote:
>> On Wed, Jun 2, 2010 at 05:29, Sonic Zhang wrote:
>>> On Wed, Jun 2, 2010 at 5:02 PM, Mike Frysinger wrote:
>>>> On Wed, Jun 2, 2010 at 04:51, sonic zhang wrote:
>>>>> +static const struct ad5398_current_data_format ad5398_df = {10, 4};
>>>>> +static const struct ad5398_current_data_format ad5821_df = {10, 4};
>>>>> +
>>>>> +static const struct i2c_device_id ad5398_id[] = {
>>>>> +       { "ad5398", (kernel_ulong_t)&ad5398_df },
>>>>> +       { "ad5821", (kernel_ulong_t)&ad5821_df },
>>>>> +       { }
>>>>> +};
>>>>
>>>> do you really need sep storage for these _df vars ?
>>>
>>> Yes, this makes probe code simpler.
>>
>> how does it make any difference to the probe code what each id is
>> pointing to ?  it isnt comparing the private data pointers to any
>> other storage pointers.
>>
>> from what i can see, this should give the same exact behavior:
>> static const struct ad5398_current_data_format df_10_4 = {10, 4};
>> static const struct i2c_device_id ad5398_id[] = {
>>       { "ad5398", (kernel_ulong_t)&df_10_4 },
>>       { "ad5821", (kernel_ulong_t)&df_10_4 },
>
> Yes, the behavior is the same for ad5398 and ad5821. But, if more
> chips are enabled in this driver, they may differ.
> This line is used as an example for future chips.

seems like a weak reason for otherwise useless overhead.  especially
considering my simpler example should also be pretty obvious to extend
for future drivers should the need arise.  you're a smart guy and dont
need things spelled out explicitly.
-mike
