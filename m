Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2ILNeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:34:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56384 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2ILNeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <1347454564-5178-2-git-send-email-peter.senna@gmail.com>
References: <1347454564-5178-2-git-send-email-peter.senna@gmail.com>
Date: Wed, 12 Sep 2012 10:34:01 -0300
Message-ID: <CAH0vN5+ZoexHtmgyZ+s9tiW3LYx+6PMT8aLyYt-T5mnaGXvYbQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] drivers/media/platform/davinci/vpbe.c: Removes
 useless kfree()
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/12 Peter Senna Tschudin <peter.senna@gmail.com>:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Remove useless kfree() and clean up code related to the removal.
>
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> position p1,p2;
> expression x;
> @@
>
> if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }
>
> @unchanged exists@
> position r.p1,r.p2;
> expression e <= r.x,x,e1;
> iterator I;
> statement S;
> @@
>
> if (x@p1 == NULL) { ... when != I(x,...) S
>                         when != e = e1
>                         when != e += e1
>                         when != e -= e1
>                         when != ++e
>                         when != --e
>                         when != e++
>                         when != e--
>                         when != &e
>    kfree@p2(x); ... return ...; }
>
> @ok depends on unchanged exists@
> position any r.p1;
> position r.p2;
> expression x;
> @@
>
> ... when != true x@p1 == NULL
> kfree@p2(x);
>
> @depends on !ok && unchanged@
> position r.p2;
> expression x;
> @@
>
> *kfree@p2(x);
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>  drivers/media/platform/davinci/vpbe.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index c4a82a1..1125a87 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -771,7 +771,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         return 0;
>
>  vpbe_fail_amp_register:
> -       kfree(vpbe_dev->amp);

Now that you removed this kfree, you could remove this label too. Very
nice your cleanup :)

>  vpbe_fail_sd_register:
>         kfree(vpbe_dev->encoders);
>  vpbe_fail_v4l2_device:
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
