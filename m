Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2IZIKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:10:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:51754 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab2IZIKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="149198818"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
Thread-Topic: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
Thread-Index: AQHNm70SsGDPqcfIUU+NDp7I0s9XrJecQ+0A
Date: Wed, 26 Sep 2012 08:10:04 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A18A27F@SHSMSX101.ccr.corp.intel.com>
References: <1348669924.19514.6.camel@cliu38-desktop-build>
 <5062A442.2030207@linux.vnet.ibm.com>
 <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com>
 <5062B602.6000502@linux.vnet.ibm.com>
In-Reply-To: <5062B602.6000502@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8AM2t030352

> Btw, on a slightly different note, I'm also rather surprised that the above
> code doesn't care about the return value of chip->irq_set_affinity() ..
> Shouldn't we warn if that fails?

It seems another case when irq_set_affinity is NULL whenever affinity is changed or not before that,
For this case, I suppose the chip is not supporting set_affinity, then the chip should set all
related irqs into just CPU0, otherwise, it will bring some trouble, do you agree?

I guess this case should be covered outside fixup_irqs() code.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
