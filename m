Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GRGmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:42:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40183 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2GRGl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:41:59 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <201207172122.26201.rjw@sisk.pl>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
 <CAMP5XgfF3RF1hSonS_QrC8jQZyCcNfwGYZcCxnew02Rp3-CXKA@mail.gmail.com>
 <CAHO5Pa3nWvmWY9jFZ-4ayvjGAV-4Vhs5sS18dbzniJp8wZYmoQ@mail.gmail.com> <201207172122.26201.rjw@sisk.pl>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 18 Jul 2012 08:41:37 +0200
Message-ID: <CAKgNAkgudHT_PC7OnjmbL1eL2dssFeLcxp90kSFTZkqGuFaa=w@mail.gmail.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while
 epoll events are ready
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 9:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

[...]

> I'm going to push your patch for v3.5,

Thanks.

> but then I'm considering the following
> one for v3.6.  I wouldn't like to make more changes in v3.5-rc at this point,

Acked-by: Michael Kerrisk <mtk.man-pages@gmail.com>

Thanks,

Michael

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Require CAP_BLOCK_SUSPEND to use wake_lock/wake_unlock
>
> Require processes wanting to use the wake_lock/wake_unlock sysfs
> files to have the CAP_BLOCK_SUSPEND capability, which also is
> required for the eventpoll EPOLLWAKEUP flag to be effective, so that
> all interfaces related to blocking autosleep depend on the same
> capability.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/wakelock.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> Index: linux/kernel/power/wakelock.c
> ===================================================================
> --- linux.orig/kernel/power/wakelock.c
> +++ linux/kernel/power/wakelock.c
> @@ -9,6 +9,7 @@
>   * manipulate wakelocks on Android.
>   */
>
> +#include <linux/capability.h>
>  #include <linux/ctype.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
> @@ -188,6 +189,9 @@ int pm_wake_lock(const char *buf)
>         size_t len;
>         int ret = 0;
>
> +       if (!capable(CAP_BLOCK_SUSPEND))
> +               return -EPERM;
> +
>         while (*str && !isspace(*str))
>                 str++;
>
> @@ -231,6 +235,9 @@ int pm_wake_unlock(const char *buf)
>         size_t len;
>         int ret = 0;
>
> +       if (!capable(CAP_BLOCK_SUSPEND))
> +               return -EPERM;
> +
>         len = strlen(buf);
>         if (!len)
>                 return -EINVAL;



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
