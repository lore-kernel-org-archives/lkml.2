Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1HKQnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:43:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11146 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1HKQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:42:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 11 Aug 2011 09:42:55 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Thu, 11 Aug 2011 09:42:54 -0700
Subject: RE: [PATCH RESEND] Input: tegra-kbc - correct call to
 input_free_device
Thread-Topic: [PATCH RESEND] Input: tegra-kbc - correct call to
 input_free_device
Thread-Index: AcxYA7eevA9WQMMyTTS02HKPe17wVwAQeODQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24C0A@HQMAIL01.nvidia.com>
References: <1313052569.2139.1.camel@phoenix>
In-Reply-To: <1313052569.2139.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7BGh9UN009049

Axel Lin wrote at Thursday, August 11, 2011 2:49 AM:
> If kzalloc for kbc fails, then we have NULL pointer dereference while
> calling input_free_device(kbc->idev) in the error handling.
> So it is safer to always use the original name, input_dev.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Reviewed-by: Stephen Warren <swarren@nvidia.com>

> ---
>  drivers/input/keyboard/tegra-kbc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> index 2b3b73e..8e40f2b 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -701,7 +701,7 @@ err_iounmap:
>  err_free_mem_region:
>  	release_mem_region(res->start, resource_size(res));
>  err_free_mem:
> -	input_free_device(kbc->idev);
> +	input_free_device(input_dev);
>  	kfree(kbc);
> 
>  	return err;
> --
> 1.7.4.1

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
