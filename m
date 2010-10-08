Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab0JHSUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:20:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0JHSUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jTMCGcL/SD54DWBvkPDnwcbyfyc90VBF0z/ywk+iq7VqFMJx7R3NvG66nSBCfaY1fZ
         nygpfcCcbHARBHYbvv8IWvZkHhYp+w4fkn54v+K3c0OrXKU1pgElyH2T8jxitzowbopH
         1I8hR9lK6ur63AuXG/13GwEP/JpN3pf6YDoaI=
MIME-Version: 1.0
In-Reply-To: <20101008141627.GN341@redhat.com>
References: <20101008141627.GN341@redhat.com>
Date: Fri, 8 Oct 2010 11:20:18 -0700
Message-ID: <AANLkTin9zgZnoNzpvzMrEfTkSRoom1DhwUhUjxWbNNF4@mail.gmail.com>
Subject: Re: [PATCH] wacom: fix pressure in Cintiq 21UX2
From: Ping Cheng <pinglinux@gmail.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 7:16 AM, Aristeu Rozanski <aris@redhat.com> wrote:
> Currently the pressure range in Cintiq 21UX2 is limited to half of the
> supported. This patch fixes the problem.
>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Acked-by: Ping Cheng <pingc@wacom.com>

Thank you Aristeu.

Dmitry, this patch should be backported since it is a bug fix.

Ping

> ---
>  drivers/input/tablet/wacom_wac.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- linus-2.6.orig/drivers/input/tablet/wacom_wac.c     2010-09-22 14:52:22.000000000 -0400
> +++ linus-2.6/drivers/input/tablet/wacom_wac.c  2010-10-07 17:20:30.000000000 -0400
> @@ -442,7 +442,8 @@ static void wacom_intuos_general(struct
>        /* general pen packet */
>        if ((data[1] & 0xb8) == 0xa0) {
>                t = (data[6] << 2) | ((data[7] >> 6) & 3);
> -               if (features->type >= INTUOS4S && features->type <= INTUOS4L)
> +               if (features->type >= INTUOS4S && features->type <= INTUOS4L ||
> +                   features->type == WACOM_21UX2)
>                        t = (t << 1) | (data[1] & 1);
>                input_report_abs(input, ABS_PRESSURE, t);
>                input_report_abs(input, ABS_TILT_X,
>
