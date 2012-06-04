Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2FDSuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:50:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:31604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2FDSut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:50:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="152558378"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [patch 1/2] x86: mce Cleanup timer mess
Thread-Topic: [patch 1/2] x86: mce Cleanup timer mess
Thread-Index: AQHNOdZUWhTwJ+tTJkK+DEa/k5xqXpbp83IAgACTaMA=
Date: Mon, 4 Jun 2012 18:14:38 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F7E3F@ORSMSX104.amr.corp.intel.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.391516712@linutronix.de> <4FCC1BE4.3070404@linux.intel.com>
In-Reply-To: <4FCC1BE4.3070404@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q54IotDO030289

> Here Thomas changed original mode from "*n = max(*n/2, HZ/100);"
> to "iv = max(iv, (unsigned long) HZ/100);", which means *iv* will not
> be decremented but only incremented in _else_ branch. If so, eventually
> the *iv will be equal to *check_interval*. I don't think it makes sense.

It looks like Thomas just forgot the "/ 2" there while cleaning up.
I didn't see it either, nor did Boris when he acked it. Thank goodness
for your extra eyes looking at this.

Please send patch to fix it (so you get credit).

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
