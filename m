Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HPGNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:13:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28617 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1HPGNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:13:09 -0400
X-AuditID: cbfee60e-b7bb3ae000005103-fa-4e4a0a693ad2
Date: Tue, 16 Aug 2011 06:12:57 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power: max17042: do not lose accuracy calculating
 current_now
To: Philip Rakity <prakity@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110816061207602@myungjoo.ham
Msgkey: 20110816061207602@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110816061207602@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26076760.93301313475177035.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7G6DOot027685

Philip Rakity<prakity@marvell.com> Date : 2011-08-13 13:19 (GMT+09:00)
> 
> PROP_CURRENT_NOW value is first divided then multiplied up
> causing a lose of accuracy.  Use the same method as
> PROP_CURRENT_AVG to do the calculation.
> 
> Signed-off-by: Philip Rakity 

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/power/max17042_battery.c |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index 4245806..7b7762a 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -153,8 +153,7 @@ static int max17042_get_property(struct power_supply *psy,
> val->intval++;
> val->intval *= -1;
> }
> - val->intval >>= 4;
> - val->intval *= 1000000 * 25 / chip->pdata->r_sns;
> + val->intval *= 1562500 / chip->pdata->r_sns;
> } else {
> return -EINVAL;
> }
> -- 
> 1.7.0.4
> 
> 
> 



 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
