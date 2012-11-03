Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab2KCHdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 03:33:10 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52459 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2KCHdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 03:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120928201506.526781717@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
	<20120928201506.526781717@linuxfoundation.org>
Date: Sat, 3 Nov 2012 00:33:07 -0700
Message-ID: <CAMbhsRRP5ui-10hMEFYk2Rh93XrvKeircsZXsySE7YXF92qigQ@mail.gmail.com>
Subject: Re: [ 044/218] Staging: Android alarm: IOCTL command encoding fix
From: Colin Cross <ccross@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, "Dae S. Kim" <dae@velatum.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 1:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "Dae S. Kim" <dae@velatum.com>
>
> commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 upstream.
>
> Fixed a bug. Data was being written to user space using an IOCTL
> command encoded with _IOC_WRITE access mode.
>
> Signed-off-by: Dae S. Kim <dae@velatum.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/staging/android/android_alarm.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- a/drivers/staging/android/android_alarm.h
> +++ b/drivers/staging/android/android_alarm.h
> @@ -110,10 +110,12 @@ enum android_alarm_return_flags {
>  #define ANDROID_ALARM_WAIT                  _IO('a', 1)
>
>  #define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
> +#define ALARM_IOR(c, type, size)            _IOR('a', (c) | ((type) << 4), size)
> +
>  /* Set alarm */
>  #define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
>  #define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
> -#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
> +#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOR(4, type, struct timespec)
>  #define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
>  #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
>  #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This patch breaks Android userspace by changing the ioctl ABI to
/dev/alarm.  It's definitely not a bug fix, as the IOW vs. IOR flag is
only ever used by drivers, and is not used by alarm-dev.c.

I would have commented sooner, but the original patch was not sent to
any lists I am on, nor any lists that Google can find.
