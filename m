Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1BNATZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:19:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40176 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab1BNATT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TC1U0BUEabvXRHu5qNv/roHE2xcinTHQAVqXofKd8wLb+BShWA/iDZ12y+3gbDkonb
         HjNvKp+e47hAfOEUNLa/Qw8wKapU+k43mQMqX7hkedSG9z/zH18DUdOoOAmpAarLzP1k
         e9tq8yXQP0MEfGtYoWZSJ/HkFpe+L/gCnF4gE=
MIME-Version: 1.0
In-Reply-To: <1297414270.14046.1.camel@mola>
References: <1297414270.14046.1.camel@mola>
Date: Mon, 14 Feb 2011 09:19:18 +0900
X-Google-Sender-Auth: dsfc4XbQktlxm8pY6EYlf4h_I6E
Message-ID: <AANLkTin14rCD1y8sLmSffA4Yhv5WZLXbn9nXPSEn=fCQ@mail.gmail.com>
Subject: Re: [PATCH] video: s3c-fb: return proper error if clk_get fails
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Fri, Feb 11, 2011 at 5:51 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Return PTR_ERR(sfb->bus_clk) instead of 0 if clk_get fails.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/s3c-fb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 83ce9a0..6817d18 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -1340,6 +1340,7 @@ static int __devinit s3c_fb_probe(struct platform_device *pdev)
>        sfb->bus_clk = clk_get(dev, "lcd");
>        if (IS_ERR(sfb->bus_clk)) {
>                dev_err(dev, "failed to get bus clock\n");
> +               ret = PTR_ERR(sfb->bus_clk);
>                goto err_sfb;
>        }
>
> --
> 1.7.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
