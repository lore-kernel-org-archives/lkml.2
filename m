Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2ITXJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:09:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:46473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab2ITXJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:09:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,457,1344236400"; 
   d="scan'208";a="224657070"
From: "Luck, Tony" <tony.luck@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: RE: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Thread-Topic: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Thread-Index: AQHNlLD6UUggHZobd0mcEpKcavm2tZeUUpQA//+L8tA=
Date: Thu, 20 Sep 2012 23:09:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
In-Reply-To: <20120920225727.GD29721@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8KNA1xf007159

> Mm... why break?

We don't know what the back-end driver will do if we allow another call
while a previous one is still in progress.  It might end up corrupting the
backing non-volatile storage and losing some previously saved records.

Existing drivers (ERST and EFI) are dependent on f/w ... so things might
work on some platforms, yet be horribly bad on others.

The patch as it was written converts a deadlock (hang) case into a "lose
this log, but keep going" case. Which seems to be an improvement without
taking any risks about what the backend will do.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
