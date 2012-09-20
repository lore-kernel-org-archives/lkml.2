Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2ITXsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:48:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:30473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab2ITXse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,457,1344236400"; 
   d="scan'208";a="195557175"
From: "Luck, Tony" <tony.luck@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: RE: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Thread-Topic: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Thread-Index: AQHNlLD6UUggHZobd0mcEpKcavm2tZeUUpQA//+L8tCAAHvqAP//jxHA
Date: Thu, 20 Sep 2012 23:48:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D43892@ORSMSX108.amr.corp.intel.com>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
 <20120920232536.GB8209@lizard>
In-Reply-To: <20120920232536.GB8209@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8KNmduB007310

> True, but the lock is used to protect pstore->buf, I doubt that
> any backend will actually want to grab it, no?

The lock is doing double duty to protect the buffer, and the back-end driver.

But even if we split it into two (one for the buffer, taken by pstore, and one
internal to the backend to protect interaction with the f/w). Ifwe ignore the
fact that we can't get the lock that protects  the buffer means it is very likely
that we corrupt the previous record that was being written by clobbering the
buffer with the data for this new record.

I'd prefer to maximize the chances that the earlier record gets written.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
