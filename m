Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2AJIZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:25:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38728 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2AJIZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:25:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120109082412.GC4049@core.coreip.homeip.net>
References: <1325847795-30486-1-git-send-email-clchiou@chromium.org> <20120109082412.GC4049@core.coreip.homeip.net>
From: Che-liang Chiou <clchiou@chromium.org>
Date: Tue, 10 Jan 2012 16:24:37 +0800
X-Google-Sender-Auth: kejjEvigKhn4yDjbHVfz2Sqjh5o
Message-ID: <CANJuy2KrSaqW2XTm4R1+y+KSRZtaNd1_mXW4pP3sOn-_B+h0sw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: serio_raw - cosmetic fixes
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 4:24 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Che-Liang,
>
> On Fri, Jan 06, 2012 at 07:03:14PM +0800, Che-Liang Chiou wrote:
>> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
>> ---
>>  drivers/input/serio/serio_raw.c |    4 +---
>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
>> index 4d4cd14..a935c38 100644
>> --- a/drivers/input/serio/serio_raw.c
>> +++ b/drivers/input/serio/serio_raw.c
>> @@ -220,7 +220,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
>>                       goto out;
>>               }
>>               written++;
>> -     };
>> +     }
>>
>
> I applied this chunk, thanks.
>
>>  out:
>>       mutex_unlock(&serio_raw_mutex);
>> @@ -231,11 +231,9 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
>>  {
>>       struct serio_raw_client *client = file->private_data;
>>       struct serio_raw *serio_raw = client->serio_raw;
>> -     unsigned int mask;
>>
>>       poll_wait(file, &serio_raw->wait, wait);
>>
>> -     mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
>>       if (serio_raw->head != serio_raw->tail)
>>               return POLLIN | POLLRDNORM;
>>
>
> This however is not quite correct. I will be applying the patch below
> instead.

Yeah I was wondering maybe you are going to make use of mask
somewhere. But still the patch below is quite strange. To my
understanding the mask is still not used; It is a local variable that
not does not make any side effect. Do you intend to use that mask on
any global state or return value?

> Thanks.
>
> --
> Dmitry
>
> Input: serio-raw - really signal HUP upon disconnect
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Commit 8c1c10d5706bbb3b41cb4a5578339d67d3eeffc2 attempted to signal
> POLLHUP | POLLERR condition when polling disconnected device,
> unfortunately it did not do it quite correctly.
>
> Reported-by: Che-Liang Chiou <clchiou@chromium.org>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/serio/serio_raw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
> index ca78a89..c2c6ad8 100644
> --- a/drivers/input/serio/serio_raw.c
> +++ b/drivers/input/serio/serio_raw.c
> @@ -237,7 +237,7 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
>
>        mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
>        if (serio_raw->head != serio_raw->tail)
> -               return POLLIN | POLLRDNORM;
> +               mask |= POLLIN | POLLRDNORM;

It seems that mask is a local variable that seems have no effect to
any global state?

>        return 0;
>  }
