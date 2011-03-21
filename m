Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1CUINA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:13:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55719 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1CUIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:12:56 -0400
Date: Mon, 21 Mar 2011 08:12:53 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd tree
 related)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110321080907058@myungjoo.ham
Msgkey: 20110321080907058@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110321080907058@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <24090250.39821300695171946.JavaMail.weblogic@epml12>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2L8D7KY030233

> Sender : Stephen Rothwell<sfr@canb.auug.org.au>
> Date : 2011-03-21 11:59 (GMT+09:00)
> Title : linux-next: build failure after merge of the final tree (mfd tree related)
> 
> Hi Sam,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/max8997-irq.c:170: error: unknown field 'bus_lock' specified in initializer
> drivers/mfd/max8997-irq.c:170: warning: initialization from incompatible pointer type
> drivers/mfd/max8997-irq.c:171: error: unknown field 'bus_sync_unlock' specified in initializer
> drivers/mfd/max8997-irq.c:171: warning: initialization from incompatible pointer type
> drivers/mfd/max8997-irq.c:172: error: unknown field 'mask' specified in initializer
> drivers/mfd/max8997-irq.c:172: warning: initialization from incompatible pointer type
> drivers/mfd/max8997-irq.c:173: error: unknown field 'unmask' specified in initializer
> drivers/mfd/max8997-irq.c:173: warning: initialization from incompatible pointer type
> 
> Caused by commit d7d21d394c9d ("mfd: Add MAX8997/8966 IRQ control feature").
> 
> The presence of these fields depends on
> CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED not being set.
> 
> I have reverted that commit for today.

Hello Stephen,

I've just submitted a corrected patch that works with
CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED being either set or unset.
Because it appears that we still have targets with deprecated functions,
I left the deprecated functions working as well as the new ones.

Thank you.

- MyungJoo.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
>


 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
