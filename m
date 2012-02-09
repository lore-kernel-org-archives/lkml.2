Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BIGK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:10:57 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51320 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2BIGKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <4F31DF34.8000205@am.sony.com>
References: <4F31DC31.6040303@am.sony.com>
	<4F31DF34.8000205@am.sony.com>
Date: Wed, 8 Feb 2012 22:10:54 -0800
X-Google-Sender-Auth: Kac0z6NvMuTpqam1Csr_sVw6SdY
Message-ID: <CAPz4a6CrJ2VS8-igOz5aRFAL32-xUi5a6cHa6rEqtK3B5689Og@mail.gmail.com>
Subject: Re: [PATCH 5/5] logger: clarify non-update of w_off in do_write_log_from_user
From: Dima Zavin <dima@android.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 6:34 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> Add comment to explain when w_off is not updated in case of failed second
> fragment copy to buffer.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

Acked-by: Dima Zavin <dima@android.com>

> ---
>  drivers/staging/android/logger.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 8d9d4f1..115d8ed 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -330,6 +330,12 @@ static ssize_t do_write_log_from_user(struct logger_log *log,
>
>        if (count != len)
>                if (copy_from_user(log->buffer, buf + len, count - len))
> +                       /*
> +                        * Note that by not updating w_off, this abandons the
> +                        * portion of the new entry that *was* successfully
> +                        * copied, just above.  This is intentional to avoid
> +                        * message corruption from missing fragments.
> +                        */
>                        return -EFAULT;
>
>        log->w_off = logger_offset(log, log->w_off + count);
> --
> 1.7.2.3
>
