Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030387Ab2CNCOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:14:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336Ab2CNCOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F5FF563.7080308@samsung.com>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-4-git-send-email-djkurtz@chromium.org> <4F5FF563.7080308@samsung.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 14 Mar 2012 10:13:46 +0800
X-Google-Sender-Auth: f0vGYbKRWU0LVdleICkyippParw
Message-ID: <CAGS+omCFPeYRZ=e9fRHSHVYXc3Bxr65qqPVzztwMShNxw=jr7A@mail.gmail.com>
Subject: Re: [PATCH 03/20] Input: atmel_mxt_ts - verify object size in mxt_write_object
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 9:33 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>
> On 03/13/2012 09:04 PM, Daniel Kurtz wrote:
>>
>> Don't allow writing past the length of an object.
>>
>> Signed-off-by: Daniel Kurtz<djkurtz@chromium.org>
>> ---
>>  drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
>> b/drivers/input/touchscreen/atmel_mxt_ts.c
>> index 0d4d492..e18c698 100644
>> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
>> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
>> @@ -506,7 +506,7 @@ static int mxt_write_object(struct mxt_data *data,
>>        u16 reg;
>>
>>        object = mxt_get_object(data, type);
>> -       if (!object)
>> +       if (!object || offset>= object->size)
>
>
> The object->size is actual object size - 1.
>
> +       if (!object || offset>  object->size)
>

Whoops.  Good catch.  Will move this patch after patch 08, which fixes
the object size.

>
>
>>                return -EINVAL;
>>
>>        reg = object->start_address;
>
>
