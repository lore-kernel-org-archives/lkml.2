Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2IXPCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:02:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:40141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab2IXPCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196985798"
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
Thread-Index: AQHNlLD6UUggHZobd0mcEpKcavm2tZeUUpQA//+L8tCAAHvqAP//jxHAgACE6QCABTCOkA==
Date: Mon, 24 Sep 2012 15:02:35 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D4404F@ORSMSX108.amr.corp.intel.com>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
 <20120920232536.GB8209@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43892@ORSMSX108.amr.corp.intel.com>
 <20120921003706.GB14399@lizard>
In-Reply-To: <20120921003706.GB14399@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8OF2qjl020858

> And my plan was to get rid of the fact that backends touch pstore->buf
> directly. Backends would always receive anonymous 'buf' pointer (we
> already have write_buf callback that does exactly this), and thus it

It feels like we are just shuffling the lock problem from one place
to another.  In the panic case we have to use a pre-allocated buffer
(hoping that we can allocate one seems to be a foolish plan). So
we'd need a lock around use of that buffer somewhere - whether
it is in the panic code, the pstore generic code, or the back-end
driver.

Can you describe where you'd like to end up?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
