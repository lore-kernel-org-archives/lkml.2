Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2IYLsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:48:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45453 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2IYLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:48:04 -0400
MIME-Version: 1.0
In-Reply-To: <201209251343.36240.hansverk@cisco.com>
References: <1348571784-4237-1-git-send-email-prabhakar.lad@ti.com> <201209251343.36240.hansverk@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Sep 2012 17:17:41 +0530
Message-ID: <CA+V-a8txW-bhAnG77iVNZbLBkUKD3RSdD4+VEkVQ-hKoqi+Bbw@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: vpif: set device capabilities
To: Hans Verkuil <hansverk@cisco.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Tue, Sep 25, 2012 at 5:13 PM, Hans Verkuil <hansverk@cisco.com> wrote:
> On Tue 25 September 2012 13:16:24 Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c |    4 +++-
>>  drivers/media/platform/davinci/vpif_display.c |    4 +++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index 4828888..faeca98 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -1630,7 +1630,9 @@ static int vpif_querycap(struct file *file, void  *priv,
>>  {
>>       struct vpif_capture_config *config = vpif_dev->platform_data;
>>
>> -     cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +     cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +                     V4L2_CAP_READWRITE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>       strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
>
> This should be the real driver name which is 'vpif_capture'.
>
Ok.

>>       strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
>
> For bus_info I would use: "platform:vpif_capture".
>
> The 'platform:' prefix is going to be the standard for platform drivers.
>
Ok.

>>       strlcpy(cap->card, config->card_name, sizeof(cap->card));
>> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
>> index d94b8a2..171e449 100644
>> --- a/drivers/media/platform/davinci/vpif_display.c
>> +++ b/drivers/media/platform/davinci/vpif_display.c
>> @@ -827,7 +827,9 @@ static int vpif_querycap(struct file *file, void  *priv,
>>  {
>>       struct vpif_display_config *config = vpif_dev->platform_data;
>>
>> -     cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
>> +     cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
>> +                         V4L2_CAP_READWRITE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>       strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
>
> vpif_driver
>
>>       strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
>
> Ditto: "platform:vpif_driver".
>
>>       strlcpy(cap->card, config->card_name, sizeof(cap->card));
>>
>
Ok, I'll respin v2 with all the changes.

Regards,
--Prabhakar Lad

> Regards,
>
>         Hans
