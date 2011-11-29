Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1K2EnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:43:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44371 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1K2EnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:43:13 -0500
X-AuditID: cbfee611-b7c19ae000001aed-3a-4ed46086518e
Date: Tue, 29 Nov 2011 04:43:11 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
To: Andrew Morton <akpm@linux-foundation.org>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111129043209060@myungjoo.ham
Msgkey: 20111129043209060@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111129043209060@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11079134.106781322541791106.JavaMail.weblogic@epml22>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAT4hLgx004675

Sender : Andrew Morton<akpm@linux-foundation.org>
Date : 2011-11-29 08:48 (GMT+09:00)
Title : Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
> 
> On Thu, 24 Nov 2011 18:12:18 +0900
> Donggeun Kim wrote:
> >
> > ...
> >
> > +static irqreturn_t max8997_muic_irq_handler(int irq, void *data)
> > +{
> > + struct max8997_muic_info *info = data;
> > +
> > + dev_dbg(info->dev, "irq:%d ", irq);
> > + info->irq = irq;
> > +
> > + schedule_work(&info->irq_work);
> > +
> > + return IRQ_HANDLED;
> > +}
> 
> The code does schedule_work() but I see no flush_work().  Is it
> possible for the work to still be pending after device shutdown, or
> even after rmmod?
> 

Yes, it is possible that the work is still pending or running and use data that are freed by max8997_muic_remove().

To be safe with the last-minute interrupt handling, we may need to add flush_work or cancel_work_sync at max8997_muic_remove().

> 

 MyungJoo Ham (ÇÔ¸íÁÖ)

Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
