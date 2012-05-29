Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2E2RLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:11:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:54488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2E2RLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172375770"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kay Sievers <kay@vrfy.org>, Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: RE: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Thread-Topic: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Thread-Index: AQHNOzCOBDs565gXrkyewLY3D++soJbeJ3uAgANBpAD//5vIoA==
Date: Tue, 29 May 2012 17:11:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F5F26@ORSMSX104.amr.corp.intel.com>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
	 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
In-Reply-To: <1338307620.886.21.camel@mop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4THBjlI027923

+/*
+ * Fill the provided buffer with as many of the the *youngest* kmsg records
+ * that fit into it. Repeated calls will fill the buffer with the next block
+ * of older records, not including the former ones. A return value of FALSE
+ * indicate that all records are read, including the oldest one.
+ */

I confess to not reading all of this ... but does this handle the pstore/OOPS
case? We'll use this call to pull as many records as will fit in the pstore
error record ... but almost certainly won't pull all of the console log, so
we won't see the FALSE return.

The system keeps on running.

Now another OOPS happens and pstore wants to grab the new "youngest" records,
it doesn't want to continue stepping to older records from the place it got
to on the first OOPS.  Will that work?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
