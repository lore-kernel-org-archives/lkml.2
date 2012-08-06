Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2HFBVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:21:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50098 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2HFBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:21:08 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-2d-501f1bf2c1a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Cc: kernel-janitors@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1344099049-15212-5-git-send-email-Julia.Lawall@lip6.fr>
In-reply-to: <1344099049-15212-5-git-send-email-Julia.Lawall@lip6.fr>
Subject: Re: [PATCH 5/6] drivers/video/backlight/da9052_bl.c: drop devm_kfree
 of devm_kzalloc'd data
Date: Mon, 06 Aug 2012 10:20:50 +0900
Message-id: <000b01cd7371$b7331790$259946b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1yYZKR08joCzjASB6kva/EtNlWDABD7PTw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd1P0vIBBo1H9C223pK2ONH3gdXi
	8q45bA7MHp83yQUwRnHZpKTmZJalFunbJXBlnPh5grngKk/FoXkn2BoYZ3B1MXJySAiYSHxb
	upgFwhaTuHBvPRuILSQwnVHiwha7LkYuIPsXo8TGt/uZQBJsAmoSX74cZgexRQT8JZrP7mEB
	KWIWOMAo8eJCKxNEt4tEz593YJM4BVwl5tx8yQxiCwukSbx6fhWshkVAVWLyvulgg3gFbCWe
	Tb/BCGELSvyYfA/sImYBLYnN25pYIWx5ic1r3gLN4QC6VF3i0V9diBuMJDq7G5khSkQk9r14
	xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh/YzqR2M
	KxssDjEKcDAq8fB27pMNEGJNLCuuzD3EKMHBrCTCm+4sFyDEm5JYWZValB9fVJqTWnyIUZqD
	RUmc19j7q7+QQHpiSWp2ampBahFMlomDU6qB0Yd32wGfkK2TS+Q1+3g4bhyPZCu9MXlH7aSO
	Npm5XjfzuyUtD3BVn87blRBpvLVymc/zogkqXUcPf90z7fGB6c3VFY1GVbJmp49cUlxiZsrD
	lHDzjr+l5g0FmUOrDzkzPBQqFTsyrbBvzqmSpLz7BszHlY3PWLeYBJ3WLE33+p6zRPJW+cQ4
	JZbijERDLeai4kQApobzfGkCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 05, 2012 1:51 AM Julia Lawall wrote:
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_kfree should not have to be explicitly used.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,d;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-devm_kfree(d,x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>


Acked-by: Jingoo Han <jg1.han@samsung.com>

It looks good.

Best regard,
Jingoo Han


> 
> ---
>  drivers/video/backlight/da9052_bl.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
> index b628d68..7c8626a 100644
> --- a/drivers/video/backlight/da9052_bl.c
> +++ b/drivers/video/backlight/da9052_bl.c
> @@ -129,7 +129,6 @@ static int da9052_backlight_probe(struct platform_device *pdev)
>  				       &da9052_backlight_ops, &props);
>  	if (IS_ERR(bl)) {
>  		dev_err(&pdev->dev, "Failed to register backlight\n");
> -		devm_kfree(&pdev->dev, wleds);
>  		return PTR_ERR(bl);
>  	}
> 
> @@ -149,7 +148,6 @@ static int da9052_backlight_remove(struct platform_device *pdev)
>  	wleds->state = DA9052_WLEDS_OFF;
>  	da9052_adjust_wled_brightness(wleds);
>  	backlight_device_unregister(bl);
> -	devm_kfree(&pdev->dev, wleds);
> 
>  	return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

