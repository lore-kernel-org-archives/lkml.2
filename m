Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KBQnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:43:42 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60934 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab0KBQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:43:37 -0400
Message-ID: <4CD03FB0.8000605@euromail.se>
Date: Tue, 02 Nov 2010 17:43:28 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: gimli <gimli@dark-green.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] MacBookAir3,1(3,2) applesmc support
References: <cf611abb8b842b043fd6e837cf161a39@mognix.dark-green.com>
In-Reply-To: <cf611abb8b842b043fd6e837cf161a39@mognix.dark-green.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PDJxK-0006Jd-AO.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PDJxK-0006Jd-AO 4edc38580b939bed951a03f78fdd346a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 08:17 AM, gimli wrote:

> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
> applesmc driver.
> 
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>


Thanks for this information. The patch is conflicting with a makeover currently
on review, but it is a candidate for inclusion in 2.6.37 and stable.

>  /* List of keys used to read/write fan speeds */
> @@ -1524,11 +1528,21 @@
>  	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
>  /* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
>  	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
> +/* MacBook Air 3,1: accelerometer, backlight and temperature set 15 */
> +	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
>  };

Comment "temperature set 15" is confusing.

>  /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
>   * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
>  static __initdata struct dmi_system_id applesmc_whitelist[] = {
> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2") },
> +		&applesmc_dmi_data[23]},
> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1") },
> +		&applesmc_dmi_data[23]},

What is the different between models 3,1 and 3,2? If there is no difference, a
single entry will suffice.

Thanks,
Henrik
