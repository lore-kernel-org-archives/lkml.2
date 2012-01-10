Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2AJI1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:27:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48716 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJI1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:27:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120109082745.GD4049@core.coreip.homeip.net>
References: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
 <1325847795-30486-2-git-send-email-clchiou@chromium.org> <20120109082745.GD4049@core.coreip.homeip.net>
From: Che-liang Chiou <clchiou@chromium.org>
Date: Tue, 10 Jan 2012 16:27:05 +0800
X-Google-Sender-Auth: GEbwTqkvS6jI-q2tFIOCP3srrsc
Message-ID: <CANJuy2JkzVxXAFRU4=Os8Om9i5nV9tOwSZTagTm=m2B4ntNRgA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: serio_raw - return error code instead of
 written on error
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 4:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Che-Liang,
>
> On Fri, Jan 06, 2012 at 07:03:15PM +0800, Che-Liang Chiou wrote:
>> Even if an error occurs and error code is set, serio_raw_write() returns
>> the amount of bytes written anyway.
>>
>> If this behavior is actually desirable, serio_raw_write() should not
>> even bother to set the error code because it is not intended to be
>> returned to the caller.
>
> Thank you for letting me know. The proper behavior is to return number of
> bytes successfully written in case of short (or full) transfer, and
> return appropriate error in case when we fail to transmit the very first
> byte.

Look good to me. Thanks.

> I will be applying the patch below.
>
> Thanks.
>
> --
> Dmitry
>
> Input: serio-raw - return proper result when serio_raw_write fails
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> If serio_raw_write was always returning number of bytes successfully
> sent to serio port and never signalled error condition to the caller.
> Change it so that for completely failed transfers appropriate error
> code returned to the caller (partially successful writes still return
> number of bytes transferred).
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/serio/serio_raw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
> index c2c6ad8..5d9f9b1 100644
> --- a/drivers/input/serio/serio_raw.c
> +++ b/drivers/input/serio/serio_raw.c
> @@ -224,7 +224,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
>
>  out:
>        mutex_unlock(&serio_raw_mutex);
> -       return written;
> +       return written ?: retval;
>  }
>
>  static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
