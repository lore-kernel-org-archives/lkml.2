Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2JLO5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:57:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:39079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759125Ab2JLO5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="203757259"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Topic: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
Thread-Index: AQHNqIA0xNWms64G/kSGCSQSXS8Oype1wbNA
Date: Fri, 12 Oct 2012 14:57:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com>
References: <1350045084.13178.19.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1210121427490.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121440160.2779@ionos>
 <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1210121533560.2779@ionos>
In-Reply-To: <alpine.LFD.2.02.1210121533560.2779@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On SMP an interrupt which is raised after the ack() again before the
> handler finishes, can invoke another delivery on a different CPU,
> which then sees the IRQ_INPROGESS flag, masks it and flags it
> PENDING. When the primary handler on the first CPU returns, it sees
> the PENDING flag, unmasks and invokes the handler another time.
In this case, when IRQ_INPROGRESS flag is set, on another CPU, it will
mask and ack it, if before the primary handler on the first CPU returns,
the edge interrupt is raised again, it will be lost, right?
So I think set PENDING just confirm one time, it just depends on primary handler
execution time and irq frequency.
