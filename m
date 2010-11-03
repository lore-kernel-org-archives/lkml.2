Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KCJjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:39:47 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:65501 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0KCJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:39:45 -0400
MIME-Version: 1.0
Date: Wed, 03 Nov 2010 10:39:41 +0100
From: gimli <gimli@dark-green.com>
To: <linux-kernel@vger.kernel.org>
Cc: Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH 1/6] MacBookAir3,1(3,2) applesmc support
In-Reply-To: <4CD03FB0.8000605@euromail.se>
References: <cf611abb8b842b043fd6e837cf161a39@mognix.dark-green.com> <4CD03FB0.8000605@euromail.se>
Message-ID: <16daf2365a63093624c93857a0011008@mognix.dark-green.com>
User-Agent: RoundCube Webmail/0.2.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Nov 2010 17:43:28 +0100, Henrik Rydberg <rydberg@euromail.se>
wrote:
> On 11/02/2010 08:17 AM, gimli wrote:
> 
>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
>> applesmc driver.
>> 
>> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
> 
> 
> Thanks for this information. The patch is conflicting with a makeover
> currently
> on review, but it is a candidate for inclusion in 2.6.37 and stable.
> 
>>  /* List of keys used to read/write fan speeds */
>> @@ -1524,11 +1528,21 @@
>>  	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
>>  /* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
>>  	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
>> +/* MacBook Air 3,1: accelerometer, backlight and temperature set 15 */
>> +	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
>>  };
> 
> Comment "temperature set 15" is confusing.
> 

This is a copy and paste error. Should be :

+/* MacBook Air 3,1(2): temperature set 23 */



>>  /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
>>   * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
>>  static __initdata struct dmi_system_id applesmc_whitelist[] = {
>> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2") },
>> +		&applesmc_dmi_data[23]},
>> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1") },
>> +		&applesmc_dmi_data[23]},
> 
> What is the different between models 3,1 and 3,2? If there is no
> difference, a
> single entry will suffice.

They are both the same.

lg

Edgar (gimli) Hucek

> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
