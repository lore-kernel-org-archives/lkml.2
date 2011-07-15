Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1GOW4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:56:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1GOW4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:56:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jzD8MGztgg1+CJfBC/VqNeOjx0HDFQ0otDUMOR5UiY+aEYkvpaRr1ydmYQgBiSU0D
	BQaz5iirnJTRw+AdpbjmA==
MIME-Version: 1.0
In-Reply-To: <1310769600-9234-1-git-send-email-msb@chromium.org>
References: <1310769600-9234-1-git-send-email-msb@chromium.org>
Date: Fri, 15 Jul 2011 15:56:08 -0700
X-Google-Sender-Auth: 0ulcyOYzNWUJ1iDQhr20pqve8OY
Message-ID: <CACBanvp9-Q4qOzAZZ04uWKfJN2cP6-k8APG+9PR2mnVRqhmU8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] panic: panic=-1 for immediate reboot
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 3:39 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> From: Hugh Dickins <hughd@chromium.org>
>
> When kernel BUG or oops occurs, ChromeOS intends to panic and immediately
> reboot, with stacktrace and other messages preserved in RAM across reboot.
> But the longer we delay, the more likely the user is to poweroff and lose
> the info.
>
> panic_timeout (seconds before rebooting) is set by panic= boot option
> or sysctl or /proc/sys/kernel/panic; but 0 means wait forever, so at
> present we have to delay at least 1 second.
>
> Let a negative number mean reboot immediately (with the small cosmetic
> benefit of suppressing that newline-less "Rebooting in %d seconds.."
> message).
>

Ignore this patch. I re-posted the series with documentation updates:

http://lkml.kernel.org/r/1310770401-10739-1-git-send-email-msb@chromium.org

> Signed-off-by: Hugh Dickins <hughd@chromium.org>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Olaf Hering <olaf@aepfle.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  kernel/panic.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 6923167..d7bb697 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -119,6 +119,8 @@ NORET_TYPE void panic(const char * fmt, ...)
>                        }
>                        mdelay(PANIC_TIMER_STEP);
>                }
> +       }
> +       if (panic_timeout != 0) {
>                /*
>                 * This will not be a clean reboot, with everything
>                 * shutting down.  But if there is a chance of
> --
> 1.7.3.1
>
>
