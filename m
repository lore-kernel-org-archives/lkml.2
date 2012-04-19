Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2DSTqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:46:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48459 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2DSTqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F9069F2.8020201@redhat.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
	<1334723412-5034-7-git-send-email-marcos.souza.org@gmail.com>
	<4F9069F2.8020201@redhat.com>
Date: Thu, 19 Apr 2012 16:46:37 -0300
Message-ID: <CAH0vN5LoFoCh0f1L01FHmSwBEq+_0RjBVPgmH48MM=FGM=djYg@mail.gmail.com>
Subject: Re: [PATCH 06/12] drivers: media: video: tlg2300: pd-video.c: Include
 version.h header
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19 de abril de 2012 16:39, Mauro Carvalho Chehab
<mchehab@redhat.com> escreveu:
> Em 18-04-2012 01:30, Marcos Paulo de Souza escreveu:
>> The output of "make versioncheck" told us that:
>>
>> drivers/media/video/tlg2300/pd-video.c: 1669: need linux/version.h
>>
>> If we take a look at the code, we can see that this file uses the macro
>> KERNEL_VERSION. So, we need this include.
>
> Nack. The right fix here is just the opposite: to remove the KERNEL_VERSION()
> call. The V4L2 core now fills it automatically, so drivers shouldn't touch on
> cap->version anymore. See the enclosed patch.
>
>>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Huang Shijie <shijie8@gmail.com>
>> Cc: Kang Yong <kangyong@telegent.com>
>> Cc: Zhang Xiaobing <xbzhang@telegent.com>
>> Cc: <linux-media@vger.kernel.org>
>> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
>> ---
>>  drivers/media/video/tlg2300/pd-video.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
>> index a794ae6..069db9a 100644
>> --- a/drivers/media/video/tlg2300/pd-video.c
>> +++ b/drivers/media/video/tlg2300/pd-video.c
>> @@ -5,6 +5,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/sched.h>
>>  #include <linux/slab.h>
>> +#include <linux/version.h>
>>
>>  #include <media/v4l2-ioctl.h>
>>  #include <media/v4l2-dev.h>
>
> commit f8bf305b7103857708cd22b504a70ea4a08022fc
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Thu Apr 19 16:35:27 2012 -0300
>
>    tlg2300: Remove usage of KERNEL_VERSION()
>
>    As reported by Marcos:
>
>    On 04-18-2012 01:30, Marcos Paulo de Souza wrote:
>    > The output of "make versioncheck" told us that:
>    >
>    > drivers/media/video/tlg2300/pd-video.c: 1669: need linux/version.h
>    >
>    > If we take a look at the code, we can see that this file uses the macro
>    > KERNEL_VERSION.
>
>    The V4L2 core now fills it automatically, so drivers shouldn't touch on
>    cap->version anymore.
>
>    Reported by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
> index a794ae6..bfbf9e5 100644
> --- a/drivers/media/video/tlg2300/pd-video.c
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -150,7 +150,6 @@ static int vidioc_querycap(struct file *file, void *fh,
>        strcpy(cap->driver, "tele-video");
>        strcpy(cap->card, "Telegent Poseidon");
>        usb_make_path(p->udev, cap->bus_info, sizeof(cap->bus_info));
> -       cap->version = KERNEL_VERSION(0, 0, 1);
>        cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
>                                V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
>                                V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;

Better yet :)

Thanks for the feedback Mauro!

-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
