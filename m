Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2BIF45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:56:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59708 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2BIF4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <4F31DE31.3040001@am.sony.com>
References: <4F31DC31.6040303@am.sony.com>
	<4F31DE31.3040001@am.sony.com>
Date: Wed, 8 Feb 2012 21:56:54 -0800
X-Google-Sender-Auth: vG8pp3AGBXEEzCfT_WTCBDLCJ9g
Message-ID: <CAPz4a6DiPaSAF3ZhmnTDnjwXHXv0at32QTMmRrgP8VyLOSG_Ug@mail.gmail.com>
Subject: Re: [PATCH 3/5] logger: reorder prepare_to_wait and mutex_lock
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

On Tue, Feb 7, 2012 at 6:30 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> If mutex_lock waits, it will return in state TASK_RUNNING,
> rubbing out the effect of prepare_to_wait().
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

Acked-by: Dima Zavin <dima@android.com>

> ---
>  drivers/staging/android/logger.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 92cfd94..54b7cdf 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -172,9 +172,10 @@ static ssize_t logger_read(struct file *file, char __user *buf,
>
>  start:
>        while (1) {
> +               mutex_lock(&log->mutex);
> +
>                prepare_to_wait(&log->wq, &wait, TASK_INTERRUPTIBLE);
>
> -               mutex_lock(&log->mutex);
>                ret = (log->w_off == reader->r_off);
>                mutex_unlock(&log->mutex);
>                if (!ret)
> --
> 1.7.2.3
>
