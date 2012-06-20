Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2FTKdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:33:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22138 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2FTKdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:33:01 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-f9-4fe1a6d68bfe
Message-id: <4FE1A6D4.2070006@samsung.com>
Date: Wed, 20 Jun 2012 19:32:52 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] video: backlight: remove unused header
References: <1339573651.30984.130.camel@x61.thuisdomein>
 <4FE1233E.9040801@gmx.de>
In-reply-to: <4FE1233E.9040801@gmx.de>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd3ryx76G2z7w2pxou8Dq8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp49P0NS8FU0Yru/lVsDYw/BboYOTkkBEwkXm3czA5h
	i0lcuLeerYuRi0NIYDqjxK9161ghnDeMEve/3mLsYuTg4BXQkth40ACkgUVAVaL10XtWEJtN
	QEPi9L37YINEBQIkNraeAbN5BQQlfky+xwJiiwhYSJy8/YEZZCazwDpGibeNV8CahQWsJda1
	bGMGsYUEQiROvL3JBmJzCqhJLDu8FKyZWUBdYtK8RcwQtrzE5jVvmScwCsxCsmMWkrJZSMoW
	MDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgOxmfSOxhXNVgcYhTgYFTi4T0x56G/EGti
	WXFl7iFGCQ5mJRHe8g6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd4m6wv+QgLpiSWp2ampBalF
	MFkmDk6pBsaougOM3Z0FqhdusN8R8dl4wY+TUVb4aXzMm79XpDbvEgna5T0976j3PoumYj3x
	rk8H1qSImYY5ap/Y+j+zdd/nLO9PrCbrZxpNmm0beeQp58rUvEjlH1us5oZd37Ru3ZXji48d
	imXR/XlHmM8mIWVuvMZC/RkJra1LXT/OafCMeaUqnP9HokGJpTgj0VCLuag4EQCdqHiqQgIA	AA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/2012 10:11 AM, Florian Tobias Schandinat wrote:

> Hi Paul,
> 
> On 06/13/2012 07:47 AM, Paul Bolle wrote:
>> Commit 9befe40f6e018e508b047eb76d189ede9b4ff03d ("video: backlight:
>> support s6e8ax0 panel driver based on MIPI DSI") added s6e8ax0.h, but
>> no file includes it. That's probably a good thing, because it declares
>> an extern void function that is defined static int in s6e8ax0.c.
>> Besides, that function is also wrapped in the module_init() macro, which
>> should do everything needed to make that function available to the code
>> outside of s6e8ax0.c. This header can safely be removed.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> it would have been a good idea to CC the authors of this file to get an
> answer to your questions and allow them to comment on the patch. (done)
> I'd like to hear their feedback before I apply your patch but it looks
> reasonable.
> 
> 
> Thanks,
> 
> Florian Tobias Schandinat
> 
>> ---
>> 0) Tested mainly by using various git tools on the (history of the)
>> tree.
>>
>> 1) Shouldn't s6e8ax0_init() and s6e8ax0_exit(), both in s6e8ax0.c, carry
>> the usual __init and __exit attributes?
>>
>> 2) But note that all the module related code in s6e8ax0.c seems moot
>> currently: EXYNOS_LCD_S6E8AX0 is a boolean Kconfig symbol, so the code
>> can only be used builtin. So, as far as I can tell, either that symbol
>> (and the symbols on which it depends) should be made tristate, or the
>> module related code can be removed from s6e8ax0.c.
>>
>>  drivers/video/exynos/s6e8ax0.h |   21 ---------------------
>>  1 files changed, 0 insertions(+), 21 deletions(-)
>>  delete mode 100644 drivers/video/exynos/s6e8ax0.h
>>
>> diff --git a/drivers/video/exynos/s6e8ax0.h b/drivers/video/exynos/s6e8ax0.h
>> deleted file mode 100644
>> index 1f1b270..0000000
>> --- a/drivers/video/exynos/s6e8ax0.h
>> +++ /dev/null
>> @@ -1,21 +0,0 @@
>> -/* linux/drivers/video/backlight/s6e8ax0.h
>> - *
>> - * MIPI-DSI based s6e8ax0 AMOLED LCD Panel definitions.
>> - *
>> - * Copyright (c) 2011 Samsung Electronics
>> - *
>> - * Inki Dae, <inki.dae@samsung.com>
>> - * Donghwa Lee <dh09.lee@samsung.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> -*/
>> -
>> -#ifndef _S6E8AX0_H
>> -#define _S6E8AX0_H
>> -
>> -extern void s6e8ax0_init(void);
>> -
>> -#endif
>> -
> 
> 


Hi,
I had looked through that code. I agree that header file will be removed.
There is no reason to maintain it.

Thank you,
Donghwa Lee

