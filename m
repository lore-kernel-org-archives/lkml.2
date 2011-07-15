Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1GOBov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 21:44:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45025 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab1GOBot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 21:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110710125356.b6cb17c2.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<20110710125356.b6cb17c2.rdunlap@xenotime.net>
Date: Thu, 14 Jul 2011 21:44:48 -0400
Message-ID: <CACqU3MXTahX6oSsyfmejPHBL_7Fv1AKJz663k6hDQs7jCDGvtg@mail.gmail.com>
Subject: Re: [PATCH 2/9] media/radio: fix aimslab CONFIG IO PORT
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2 to 7 will be not needed. I screwed up a autoconf.h generation while
refactoring the code. This is being addressed in the kbuild tree by:

https://patchwork.kernel.org/patch/975652/

My bad,
 - Arnaud

On Sun, Jul 10, 2011 at 3:53 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Modify radio-aimslab to use HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
> so that the correct IO port value is used.
>
> Fixes this error message when CONFIG_RADIO_RTRACK_PORT=20f:
> drivers/media/radio/radio-aimslab.c:49:17: error: invalid suffix "f" on integer constant
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/media/radio/radio-aimslab.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> --- linux-next-20110707.orig/drivers/media/radio/radio-aimslab.c
> +++ linux-next-20110707/drivers/media/radio/radio-aimslab.c
> @@ -32,6 +32,7 @@
>  #include <linux/init.h>                /* Initdata                     */
>  #include <linux/ioport.h>      /* request_region               */
>  #include <linux/delay.h>       /* msleep                       */
> +#include <linux/stringify.h>
>  #include <linux/videodev2.h>   /* kernel radio structs         */
>  #include <linux/io.h>          /* outb, outb_p                 */
>  #include <media/v4l2-device.h>
> @@ -43,10 +44,12 @@ MODULE_LICENSE("GPL");
>  MODULE_VERSION("0.0.3");
>
>  #ifndef CONFIG_RADIO_RTRACK_PORT
> -#define CONFIG_RADIO_RTRACK_PORT -1
> +#define __RADIO_RTRACK_PORT -1
> +#else
> +#define __RADIO_RTRACK_PORT HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
>  #endif
>
> -static int io = CONFIG_RADIO_RTRACK_PORT;
> +static int io = __RADIO_RTRACK_PORT;
>  static int radio_nr = -1;
>
>  module_param(io, int, 0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
