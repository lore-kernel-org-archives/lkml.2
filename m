Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab1FTTFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:05:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1FTTFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WaeFVLPura2nAmMHRG4R/FE20ULUQwv5Gbx6TaIOEPB5vjKtvpXPLx0HGNhQT/gJq4
         SVXiay5zNVKviI0ibTq13P3fs3gjHtpbMeuB0DTxFC6wYw2SrtRhU1GULe4Kxv3HFd7i
         YoHD8UXqeSD4rwKnPP9/SRiWtBt36o7U5k2Nw=
MIME-Version: 1.0
In-Reply-To: <20110620173444.GG26623@legolas.emea.dhcp.ti.com>
References: <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
	<20110620151522.GN14262@legolas.emea.dhcp.ti.com>
	<BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
	<20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
	<BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
	<BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
	<20110620160650.GA26623@legolas.emea.dhcp.ti.com>
	<BANLkTi=nEma5muF9R3_QUzZWWJ64DW9Skw@mail.gmail.com>
	<20110620170551.GE26623@legolas.emea.dhcp.ti.com>
	<BANLkTinc-9hxLQ1Epf5=PoHvxtapfO7Vvg@mail.gmail.com>
	<20110620173444.GG26623@legolas.emea.dhcp.ti.com>
Date: Mon, 20 Jun 2011 21:05:07 +0200
Message-ID: <BANLkTimaQq99BHAhBMYT_iZz4Kfag1n6Lw@mail.gmail.com>
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
From: Viliam Mateicka <viliam.mateicka@gmail.com>
To: balbi@ti.com
Cc: Skacore Systems <skacore.systems@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look. I didn't wanna spend more time with the issue because for me -
it was solved. It was just the stupid byrocratic system you've
enforced to minimize your work - which I would say its complete
non-sence if it could ever have a problem with whitespace or line
break. I understand that on the source level every character it's
important to the look of the code, but at least when you try to force
somebody to use some rules (which most of it at my copy were applied
fine just fine by myself), at least use a tool which take a care about
it (the look of the kernel code). Just look how much time it took to
upstream a little change (valid on the first look), just because of my
ignorance to some the formating rules (linebreaks and tabs namely - if
you have a proper editor which takes care about it.) and a faulty
mailer (I).

Anyway, if the Documentation/SubmittingPatches would mention git
format-patch and git send-email I would have use it and there would'nt
be any trouble using faulty mailer.  Instead as a first option there
is solution which almost everytime produces such a problems.

So many thanks, for doing your job and keeping the bad asses using
wrong tools out of the formating heaven. I could imagine that this
would be hard (to get one line into the kernel) but still haven't
thought that hard. I would like to thank you for your patience and the
exact amount of right doingness, while showing me what's wrong instead
of telling me how to do it properly.

Also liked the diff between our patches:

player tmp # diff -ur wastetime wastetime2
--- wastetime	2011-06-20 20:33:25.000000000 +0200
+++ wastetime2	2011-06-20 20:30:21.000000000 +0200
@@ -2,11 +2,12 @@
 index 100f263..b6e1ca5 100644
 --- a/drivers/usb/gadget/s3c2410_udc.c
 +++ b/drivers/usb/gadget/s3c2410_udc.c
-@@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum
s3c2410_udc_cmd_e cmd)
- 		return;
-
- 	if (udc_info->udc_command) {
--		udc_info->udc_command(S3C2410_UDC_P_DISABLE);
-+		udc_info->udc_command(cmd);
- 	} else if (gpio_is_valid(udc_info->pullup_pin)) {
- 		int value;
+@@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum
+s3c2410_udc_cmd_e cmd)
+                return;
+
+        if (udc_info->udc_command) {
+-               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
++               udc_info->udc_command(cmd);
+        } else if (gpio_is_valid(udc_info->pullup_pin)) {
+                int value;

Vilo

On Mon, Jun 20, 2011 at 7:34 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jun 20, 2011 at 07:27:18PM +0200, Viliam Mateicka wrote:
>> I wonder then, who applies the patch first. One ass can't stop
>> progress (was there some progress afterall ?) because of one
>> line-break (which git produces by default afterall) and several
>> non-conforming whitespace conversions. I think you should stop
>> replying to me, because I'm kinda starting to like trolling afterall.
>
> Look, maybe you're just new to git/linux and that's fine. The only
> problem we had from day one is that you have been a complete dick when
> replying.
>
> If you go that road, that's what you'll get in return.
>
> Just so you see the properly formatted patch, I'm quoting below. See
> that there's no line breaks introduced by git.
>
> commit c27c9b5312f4b2a7e66ee772943355d77fc2c550
> Author: Viliam Mateicka <viliam.mateicka@gmail.com>
> Date:   Mon Jun 20 19:08:27 2011 +0300
>
>    usb: gadget: s3c2410_udc: fix custom UDC command handling
>
>    There is a bug in Samsung's UDC driver, which is
>    completely disabling the USB device when a custom
>    UDC command is used.
>
>    Following patch seems to get the right behavior
>    (e.g. enabling pull-up instead of disabling then
>    Vcc is applied).
>
>    Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>
>
>    [ balbi@ti.com : manually re-created the patch because
>        author was unable to send a proper one ]
>
>    Signed-off-by: Felipe Balbi <balbi@ti.com>
>
> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
> index 100f263..b6e1ca5 100644
> --- a/drivers/usb/gadget/s3c2410_udc.c
> +++ b/drivers/usb/gadget/s3c2410_udc.c
> @@ -1567,7 +1567,7 @@ static void s3c2410_udc_command(enum s3c2410_udc_cmd_e cmd)
>                return;
>
>        if (udc_info->udc_command) {
> -               udc_info->udc_command(S3C2410_UDC_P_DISABLE);
> +               udc_info->udc_command(cmd);
>        } else if (gpio_is_valid(udc_info->pullup_pin)) {
>                int value;
>
>
> (if you see any line breaks that's your mailer, it's better to check
> from the archives [1])
>
> [1] http://marc.info/?l=linux-usb
>
> --
> balbi
>
