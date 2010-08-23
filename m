Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0HWIZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:25:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35176 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0HWIZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vuNsn+OFiZoIPvruUtfOTsSJmtg2o27xNtyHZxTiNA/DyU1vM4TG+hh8JxeRGHeTWV
         NJ5YWmbp7Y63BPVqz/NlJR7Dc2xFVsOOkCKiqOPXQptgf1QopweFmcdFEnELlz8zXR69
         YWKAXNBZVYa3iljaGy7CWSio9wjPrvtZ8A/9c=
MIME-Version: 1.0
In-Reply-To: <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at>
	<e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
Date: Mon, 23 Aug 2010 10:25:35 +0200
Message-ID: <AANLkTi=Fa38ufwR8PDc+HBHmLT53eWRA0ofrobm0n9-w@mail.gmail.com>
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:16, Richard Cochran <richardcochran@gmail.com> wrote:
> diff --git a/kernel/compat.c b/kernel/compat.c
> index 5adab05..df1e469 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -628,6 +628,26 @@ long compat_sys_clock_gettime(clockid_t which_clock,
>        return err;
>  }
>
> +long compat_sys_clock_adjtime(clockid_t which_clock, int ppb,
> +               struct compat_timespec __user *tp)
> +{
> +       long err;
> +       mm_segment_t oldfs;
> +       struct timespec ts, *ptr = NULL;

Shouldn't ptr be initialized with tp?

> +
> +       if (tp) {
> +               if (get_compat_timespec(&ts, tp))
> +                       return -EFAULT;
> +               ptr = &ts;
> +       }
> +       oldfs = get_fs();
> +       set_fs(KERNEL_DS);
> +       err = sys_clock_adjtime(which_clock, ppb,
> +                               (struct timespec __user *) ptr);
> +       set_fs(oldfs);
> +       return err;
> +}
> +
>  long compat_sys_clock_getres(clockid_t which_clock,
>                struct compat_timespec __user *tp)
>  {
