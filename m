Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1IWRLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:11:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:35946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1IWRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,431,1312182000"; 
   d="scan'208";a="70038119"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "saguchi@redhat.com" <saguchi@redhat.com>
Date: Fri, 23 Sep 2011 10:11:17 -0700
Subject: RE: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Topic: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Index: Acx5u9SEyle2xo7GSw+ERH94DJaSAQAV00eQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE3333A2@orsmsx505.amr.corp.intel.com>
References: <1316552853-2000-1-git-send-email-mjg@redhat.com>
 <4E795A9C.4040508@linux.intel.com> <20110921124018.GA22155@srcf.ucam.org>
 <4E7A9BC6.9070608@linux.intel.com> <20110922131504.GA11990@srcf.ucam.org>
 <4E7C2A15.80703@linux.intel.com>
In-Reply-To: <4E7C2A15.80703@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8NHBgaA006004

> If you insist on your design, I prefer deleting the function pstore_write before 
> applying your patch. We all know no real users to call this function,
> every backend will register Its own callback, so this function is useless at all.

We could do that. I threw in pstore_write without any particular use case in mind.
Since there hasn't been a rush of people adding calls to it (and since it seems
that pstore back ends have very limited amounts of space at their disposal, any
use of pstore_write would probably cause problems for the dmesg dump model)
removing it sounds like a good idea.

If someone does want to use it - they will have to figure out how to solve
priority issues.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
