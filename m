Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2FRCmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:42:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38038 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2FRCmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:42:54 -0400
X-AuditID: cbfee60d-b7f056d000004fc9-29-4fde95acecc2
Date: Mon, 18 Jun 2012 02:42:52 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: max8997: Add missing kfree for info->edev in
 max8997_muic_remove()
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120618023912067@myungjoo.ham
Msgkey: 20120618023912067@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120618023912067@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3920966.545511339987371711.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/tGbprpt7zNzi8Sszi8q45bA6MHp83
	yQUwRnHZpKTmZJalFunbJXBlbJu4g7HgnlDFwmmBDYxzhLoYOTmEBNQlFi05yQZiSwiYSCxa
	eZoZwhaTuHBvPVCcC6hmPqPEnx0nWboYOThYBFQl/t4MADHZBMwl7s8IAikXFoiXeH73KFir
	iECKROfk+ewgrcwCmxkl9u37wAyxS0lizb5XLCA2r4CgxMmZT1ggdqlKPNv4nxkiriaxcOMD
	Joi4hMSs6RdYIWxeiRntT6Hq5SSmfV0Ddae0xPlZGxhhbl78/TFUnF/i2O0dTCB3gvQ+uR8M
	M2b35i9Q7wpITD1zEKpVS+L61N9QrXwSaxa+ZYEZs+vUcrA4s4CixJTuh+wQtpbElx/72NC9
	wivgKHHxfifLBEbZWUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9FRjveLE3OLSvHS95PzcTYzg
	WH7Gu4NxboPFIUYBDkYlHt4LWff8hVgTy4orcw8xSnAwK4nw2rYDhXhTEiurUovy44tKc1KL
	DzFKc7AoifNOsb7gLySQnliSmp2aWpBaBJNl4uCUamB0/9a8+kzNu4mT1htsz9lse1b/Uf7H
	f1P+ckw4fPrk81s8+fL1e20UJZ1m69/eoxP1dt6c1Leie6223Y37//sjl93TeuOQrMk3vnga
	KXYElR4ufj3pRKuJcpGmflDiTb6fFobnbgTf+MQ3c1fZ/BilFq38xPKzTcn+Hz7+rP/4+1Kh
	juiyBtMqJZbijERDLeai4kQAI3L2FuECAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5I2hXs6018335

> extcon_dev_unregister(info->edev) doest not free info->edev, we need to call
> kfree(info->edev) here.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

The patch is correct.

However, using devm_kzalloc at probe and removing kfree at remove appears to be much better.

Thank you.


Cheers!
MyungJoo.

> ---
>  drivers/extcon/extcon-max8997.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 5ecf176..a4ed30b 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -514,6 +514,7 @@ static int __devexit max8997_muic_remove(struct platform_device *pdev)
>  
>  	extcon_dev_unregister(info->edev);
>  
> +	kfree(info->edev);
>  	kfree(info);
>  
>  	return 0;
> -- 
> 1.7.9.5
> 
------
Sender : Axel Lin<axel.lin@gmail.com>
Date : 2012-06-16 22:25 (GMT+09:00)
Title : [PATCH] extcon: max8997: Add missing kfree for info->edev in max8997_muic_remove()

extcon_dev_unregister(info->edev) doest not free info->edev, we need to call
kfree(info->edev) here.

Signed-off-by: Axel Lin 
---
drivers/extcon/extcon-max8997.c |    1 +
1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 5ecf176..a4ed30b 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -514,6 +514,7 @@ static int __devexit max8997_muic_remove(struct platform_device *pdev)

extcon_dev_unregister(info->edev);

+ kfree(info->edev);
kfree(info);

return 0;
-- 
1.7.9.5






--
MyungJoo Ham («‘∏Ì¡÷), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
