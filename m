Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2GCGoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:44:14 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:35676 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab2GCGoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com>
References: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com>
Date: Tue, 3 Jul 2012 12:14:10 +0530
Message-ID: <CAAe_U6J84JHSGQ2upXfnS_JPUfZwv9HD_xAyjK+8ybsZtuRpiQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: gadget: s3c-hsotg: fix core reset timeout failure
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, ben@simtec.co.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 3, 2012 at 7:33 AM, Du, Changbin <changbin.du@gmail.com> wrote:
> The timeout values were 1000 and timeout issue occured many times on my
> s3c6410 Soc based board (mostly when booting whith USB cable not
> connected). This patch increase the values to 10000 to guarantee the
> success of reset.
>
> Having set timeout to 10000, I printed the remained timeout values
> which can cause timeout issue before this change (tested several times):
> the first timeout value remained:
>         timeout = 8079
>         timeout = 8079
>         timeout = 8078
>         timeout = 8081
> the second timeout value remained:
>         timeout = 7940
>         timeout = 7945
>         timeout = 7940
>         timeout = 7938
> Seeing from above values, I think 10000 is big enough.
>
> Signed-off-by: Du, Changbin <changbin.du@gmail.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index f4abb0e..f3e2234 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
> *hsotg)
>         /* issue soft reset */
>         writel(GRSTCTL_CSftRst, hsotg->regs + GRSTCTL);
>
> -       timeout = 1000;
> +       timeout = 10000;
>         do {
>                 grstctl = readl(hsotg->regs + GRSTCTL);
>         } while ((grstctl & GRSTCTL_CSftRst) && timeout-- > 0);

how about msleep inside the loop?

Thanks
Kishon
