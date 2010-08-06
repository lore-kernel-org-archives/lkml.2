Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973Ab0HFJEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:04:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35674 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760803Ab0HFJEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wSgb8sTo6fPvI2Pna2YIIXNoR/OR5Gq/XbRQ+LCu8mwOmHUPiLdvibordm6TT7z+Uk
         /gMrrjPIf9Tl9o8hvknPdlAldw5koLoRzlkaSkyQQ9/uyQGXXFZX1lyZK9WK10/GQdob
         ac3msrIAEQA/7UBIm4RaGBluJfhiGd2riz64Q=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1008052217240.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052217240.31692@ask.diku.dk>
Date: Fri, 6 Aug 2010 11:04:20 +0200
Message-ID: <AANLkTikGYhWCVW1HqdhwqRHaph54S9U4eKi7nNLHktMV@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH 3/42] drivers/hwmon: Adjust confusing if 
	indentation
From: Charles Logan <cybercorecentre@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected:

> // <smpl>
> @r disable braces5@
> position p1,p2;
> statement S1,S2;
> @@
>
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
>
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
>
> if (p1[0].column == p2[0].column):
>  cocci.print_main("branch",p4)
>  cocci.print_secs("after",p5)
> // </smpl>



On Thu, Aug 5, 2010 at 10:17 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Move the if(err) statement after the if into the if branch indicated by its
> indentation.  The preceding if(err) test implies that err cannot be nonzero
> unless the if branch is taken.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
>
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
>
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
>
> if (p1[0].column == p2[0].column):
>  cocci.print_main("branch",p1)
>  cocci.print_secs("after",p2)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/hwmon/k8temp.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
> index 8bdf80d..b9bb3e0 100644
> --- a/drivers/hwmon/k8temp.c
> +++ b/drivers/hwmon/k8temp.c
> @@ -252,12 +252,13 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
>                                   &sensor_dev_attr_temp3_input.dev_attr);
>                if (err)
>                        goto exit_remove;
> -               if (data->sensorsp & SEL_PLACE)
> +               if (data->sensorsp & SEL_PLACE) {
>                        err = device_create_file(&pdev->dev,
>                                           &sensor_dev_attr_temp4_input.
>                                           dev_attr);
>                        if (err)
>                                goto exit_remove;
> +               }
>        }
>
>        err = device_create_file(&pdev->dev, &dev_attr_name);
>
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
>
