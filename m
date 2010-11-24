Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0KXIpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:45:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:59843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0KXIpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:45:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,247,1288594800"; 
   d="scan'208";a="860885098"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Kyungmin Park <kmpark@infradead.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        =?utf-8?B?7KCV7J6s7ZuI?= <jh80.chung@samsung.com>
Date: Wed, 24 Nov 2010 16:44:13 +0800
Subject: RE: [PATCH v1 0/4]mmc: enable eMMC4.41 new feature background
 operations and HPI
Thread-Topic: [PATCH v1 0/4]mmc: enable eMMC4.41 new feature background
 operations and HPI
Thread-Index: AcuLr1FE+V7z7BD9T46qcRB8jn9CiAAAPxSg
Message-ID: <5D8008F58939784290FAB48F549751983125B43D44@shsmsx502.ccr.corp.intel.com>
References: <20101123084309.GA17754@intel.com>
 <AANLkTinvfjAZOyuiM2T8Vtj-vxS59P1HNzjKAjPiOzb_@mail.gmail.com>
In-Reply-To: <AANLkTinvfjAZOyuiM2T8Vtj-vxS59P1HNzjKAjPiOzb_@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAO8jRx4010909

> 
> Basic question. Do you have any performance gain or improvement?
> In my test environment. no performance gain. Yes I know it's not for
> performance improvement.
My understanding:
If BKOPS feature is not enabled, the background operations will be started when card handles some read or write command. This will impact read/write performance. If BKOPS is enabled, driver can check whether need to do a BKOPS each time after card handled a read/write command. If need, driver can start BKOPS as soon as possible when user request is empty. This will can improve read/write performance.
So I think, anyhow background operations can improve the performance, but only can be seen when your test card need to do a background operations. If your card needn't, there will be no performance gain I think. Driver will works as normal.
BTW, the BKOPS is an operational features for eMMC4.41 card, to ensure whether the card support this feature, check ext_csd[502].
> 
> How to measure or check it has some improvement?
> Any ideas?
> 
Right now I didn't know how to do a precise measurement. Maybe keep on transferring large data for a long time with a card which enabled/or not the BKOPS feature can help to get some measurement data.

Thanks
Chuanxiao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
