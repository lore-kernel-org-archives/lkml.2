Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239Ab2FVFpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:45:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761202Ab2FVFpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120621135136.1e2ff338.akpm@linux-foundation.org>
References: <1340262280-15096-1-git-send-email-devendra.aaru@gmail.com>
	<20120621135136.1e2ff338.akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 11:15:36 +0530
Message-ID: <CAHdPZaPPo0LQ9H6JhRyfCzJ7tiS7-7pQD_useZmHmNWM4e9kVQ@mail.gmail.com>
Subject: Re: [PATCH] rtc/r9701: avoid second call to the rtc_valid_tm
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Anatolij Gustschin <agust@denx.de>,
        Andreas Dumberger <andreas.dumberger@tqs.de>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks a lot for the reply. :-)

On Fri, Jun 22, 2012 at 2:21 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 21 Jun 2012 12:34:40 +0530
> Looks OK.
>
>
> I think the driver would be better if we were to do this:
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded
>
> When the driver detects that the clock time is invalid, it attempts to
> write a sane time into the hardware.  We curently assume that everything
> is OK is those writes succeeded.  But it is better to re-read the time
> from the hardware to ensure that the new settings got there OK.
>
> Cc: Devendra Naga <devendra.aaru@gmail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/rtc/rtc-r9701.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff -puN drivers/rtc/rtc-r9701.c~a drivers/rtc/rtc-r9701.c
> --- a/drivers/rtc/rtc-r9701.c~a
> +++ a/drivers/rtc/rtc-r9701.c
> @@ -147,7 +147,8 @@ static int __devinit r9701_probe(struct
>                dt.tm_mon  = 0;
>                dt.tm_year = 100;
>
> -               if (r9701_set_datetime(&spi->dev, &dt)) {
> +               if (r9701_set_datetime(&spi->dev, &dt) ||
> +                               r9701_get_datetime(&spi->dev, &dt)) {
Yeah, agreed, crosschecking whether we have a valid time set at the
hardware by the r9701_set_datetime.

>                        dev_err(&spi->dev, "cannot repair RTC register\n");
>                        return -ENODEV;
>                }
> _
>
>
> But I can't test this :(

I also dont have the RTC-j9701 hardware :(.

i was thinking of cases like setting / getting of time from ioctl. but
there was no ioctl support inside the driver.

i am really a newbie in kernel, pardon me if i told anything wrong ...

Thanks,
Devendra.
