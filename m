Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab2JLP3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:29:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:54029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736Ab2JLP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:29:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="203769481"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: anish kumar <anish198519851985@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqI3GXuKKKGSRjESsjhgprhwMOJe1yz5A
Date: Fri, 12 Oct 2012 15:29:31 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A195A8D@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
	 <alpine.LFD.2.02.1210121427490.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121440160.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210121533560.2779@ionos>
	 <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com>
 <1350055478.8329.24.camel@anish-Inspiron-N5050>
In-Reply-To: <1350055478.8329.24.camel@anish-Inspiron-N5050>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9CFTeOA016306



> -----Original Message-----
> From: anish kumar [mailto:anish198519851985@gmail.com]
> Sent: Friday, October 12, 2012 11:25 PM
> To: Liu, Chuansheng
> Cc: Thomas Gleixner; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> thread
> 
> On Fri, 2012-10-12 at 14:57 +0000, Liu, Chuansheng wrote:
> > > On SMP an interrupt which is raised after the ack() again before the
> > > handler finishes, can invoke another delivery on a different CPU,
> > > which then sees the IRQ_INPROGESS flag, masks it and flags it
> > > PENDING. When the primary handler on the first CPU returns, it sees
> > > the PENDING flag, unmasks and invokes the handler another time.
> > In this case, when IRQ_INPROGRESS flag is set, on another CPU, it will
> > mask and ack it, if before the primary handler on the first CPU returns,
> > the edge interrupt is raised again, it will be lost, right?
> Why will the interrupt be raised again?Is not it masked?I read tglx
I means because it is masked, if at this time device issues edge irq,
It will not be delivered and lost.

> statement as this:if the interrupt is being handled on one core, then
> the delivery of new interrupt can be on the second core and in that case
> it will see IRQ_INPROGRESS flag and it will *mask* it and set the flag
> as pending.So there is no chance of any new interrupt.
> > So I think set PENDING just confirm one time, it just depends on primary
> handler
> > execution time and irq frequency.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
