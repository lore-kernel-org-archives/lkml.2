Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab2HVJil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:38:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21050 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2HVJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:38:38 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-c9-5034a89c353d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345365870-29831-15-git-send-email-Julia.Lawall@lip6.fr>
In-reply-to: <1345365870-29831-15-git-send-email-Julia.Lawall@lip6.fr>
Subject: RE: [PATCH 14/14] drivers/spi/spi-s3c24xx.c: fix error return code
Date: Wed, 22 Aug 2012 18:38:36 +0900
Message-id: <1b3201cd8049$e753f720$b5fbe560$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac195t+LqvvpL2P5RaqJCe9X57SqnQCTDYyg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd05K0wCDJat1bHYekva4vKuOWwW
	M87vY3Jg9vi8SS6AMYrLJiU1J7MstUjfLoErY+ajJawFj7gr3j/Yw9zA2MjZxcjJISFgItF/
	ZQYjhC0mceHeejYQW0hgEaPE5XPpXYxcQPZfRonrkzvZQRJsAhoSh98/A7NFBHwkbh1+xwRS
	xCwwm0niy6sfLBAdDYwSk55PYgGp4hRwkzj8owtshbCAt8TzK/PAVrAIqEpc2/yHGcTmFbCV
	2NC3DsoWlPgx+R5YL7OAlsT6nceZIGx5ic1r3gLVcACdqi7x6K8uxBFGEq8OnGSDKBGR2Pfi
	HeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNzPpHYw
	rmywOMQowMGoxMPrkWASIMSaWFZcmXuIUYKDWUmE93otUIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjgvf59hgJBAemJJanZqakFqEUyWiYNTqoExgyVi/9TWez80Yjlydk0o6F6yglWkzHOmGm/U
	v/CZs3nid0/dtvrcvhc+8bt4O7Oy1TofHp8T1r645866OMmn3QV9DnG7y2wu3fvHlR/IfPJh
	4WPT07wtHDmZRpw3eoNLgg8n/cjwYp+8n9m+2qxCdMWmrHknz75n2H/K5JTy05L7O0v0/U2V
	WIozEg21mIuKEwG826h9agIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize return variable before exiting on an error path.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

(Cc'ed Mark Brown who is handling spi for a moment)

> ---
> Perhaps -EINVAL is not the right value in this case.
> 
Well, if (pin_cs < 0) is true, it is really invalid value. So I think, it
makes sense :-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

>  drivers/spi/spi-s3c24xx.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/spi/spi-s3c24xx.c b/drivers/spi/spi-s3c24xx.c
> index 8ee7d79..a2a080b 100644
> --- a/drivers/spi/spi-s3c24xx.c
> +++ b/drivers/spi/spi-s3c24xx.c
> @@ -611,6 +611,7 @@ static int __devinit s3c24xx_spi_probe(struct
> platform_device *pdev)
>  	if (!pdata->set_cs) {
>  		if (pdata->pin_cs < 0) {
>  			dev_err(&pdev->dev, "No chipselect pin\n");
> +			err = -EINVAL;
>  			goto err_register;
>  		}
> 

