Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2FJMSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:18:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50933 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2FJMSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1338060326-31158-1-git-send-email-levinsasha928@gmail.com>
References: <1338060326-31158-1-git-send-email-levinsasha928@gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 10 Jun 2012 14:17:52 +0200
Message-ID: <CA+1xoqe+zhxWn0bVhZ0ZQj9R=1Eup5TBff7q=i4h2TDC8G9AWg@mail.gmail.com>
Subject: Re: [PATCH] USB: Staging: media: lirc: initialize spinlocks before usage
To: jarod@wilsonet.com, mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? This thing still causes spinlock errors in 3.5-rc2.

On Sat, May 26, 2012 at 9:25 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Initialize the spinlock for each hardware time.
>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_serial.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
> index 3295ea6..97ef670 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -129,6 +129,7 @@ static void send_space_homebrew(long length);
>
>  static struct lirc_serial hardware[] = {
>        [LIRC_HOMEBREW] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_HOMEBREW].lock),
>                .signal_pin        = UART_MSR_DCD,
>                .signal_pin_change = UART_MSR_DDCD,
>                .on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
> @@ -145,6 +146,7 @@ static struct lirc_serial hardware[] = {
>        },
>
>        [LIRC_IRDEO] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO].lock),
>                .signal_pin        = UART_MSR_DSR,
>                .signal_pin_change = UART_MSR_DDSR,
>                .on  = UART_MCR_OUT2,
> @@ -156,6 +158,7 @@ static struct lirc_serial hardware[] = {
>        },
>
>        [LIRC_IRDEO_REMOTE] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IRDEO_REMOTE].lock),
>                .signal_pin        = UART_MSR_DSR,
>                .signal_pin_change = UART_MSR_DDSR,
>                .on  = (UART_MCR_RTS | UART_MCR_DTR | UART_MCR_OUT2),
> @@ -167,6 +170,7 @@ static struct lirc_serial hardware[] = {
>        },
>
>        [LIRC_ANIMAX] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_ANIMAX].lock),
>                .signal_pin        = UART_MSR_DCD,
>                .signal_pin_change = UART_MSR_DDCD,
>                .on  = 0,
> @@ -177,6 +181,7 @@ static struct lirc_serial hardware[] = {
>        },
>
>        [LIRC_IGOR] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_IGOR].lock),
>                .signal_pin        = UART_MSR_DSR,
>                .signal_pin_change = UART_MSR_DDSR,
>                .on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
> @@ -201,6 +206,7 @@ static struct lirc_serial hardware[] = {
>         * See also http://www.nslu2-linux.org for this device
>         */
>        [LIRC_NSLU2] = {
> +               .lock = __SPIN_LOCK_UNLOCKED(hardware[LIRC_NSLU2].lock),
>                .signal_pin        = UART_MSR_CTS,
>                .signal_pin_change = UART_MSR_DCTS,
>                .on  = (UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_DTR),
> --
> 1.7.8.6
>
