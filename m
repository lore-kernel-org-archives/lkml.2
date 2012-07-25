Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2GYGJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:09:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39735 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2GYGJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120725053755.GA2100@core.coreip.homeip.net>
References: <1343193656-2643-1-git-send-email-chenbdchenbd@gmail.com>
	<20120725053755.GA2100@core.coreip.homeip.net>
Date: Wed, 25 Jul 2012 14:09:36 +0800
Message-ID: <CAEAuANPvc8bi2ezrrZPgCpm0zo_7vkHsX8W32Jv0uf-SiPsGTg@mail.gmail.com>
Subject: Re: [PATCH] fixed a macro coding style issue
From: Baodong Chen <chenbdchenbd@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch definitely changes semantics.
so please discard it, sorry about that!

On Wed, Jul 25, 2012 at 1:37 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Jul 25, 2012 at 01:20:56PM +0800, Baodong Chen wrote:
>> Fixed a coding style issue in driver/input/input.c
>>
>> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>
>> ---
>>  drivers/input/input.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/input.c b/drivers/input/input.c
>> index 8921c61..c96e983 100644
>> --- a/drivers/input/input.c
>> +++ b/drivers/input/input.c
>> @@ -845,11 +845,13 @@ int input_set_keycode(struct input_dev *dev,
>>  EXPORT_SYMBOL(input_set_keycode);
>>
>>  #define MATCH_BIT(bit, max) \
>> +     do { \
>>               for (i = 0; i < BITS_TO_LONGS(max); i++) \
>>                       if ((id->bit[i] & dev->bit[i]) != id->bit[i]) \
>>                               break; \
>> -             if (i != BITS_TO_LONGS(max)) \
>> -                     continue;
>> +                     if (i != BITS_TO_LONGS(max)) \
>> +                             continue; \
>> +     } while (0)
>
> This changes semantics. While current implementation of MATCH_BIT might
> not be great style, it is not supposed to be used outside of
> input_match_device(), and the replacement is completely broken.
>
> Thanks.
>
> --
> Dmitry
