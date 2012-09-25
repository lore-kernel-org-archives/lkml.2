Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2IYDGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:06:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:10615 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2IYDF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,478,1344236400"; 
   d="scan'208";a="212357383"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>,
        "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>
Subject: RE: [PATCH] Thermal: Fix bug on generic thermal framework.
Thread-Topic: [PATCH] Thermal: Fix bug on generic thermal framework.
Thread-Index: AQHNmfku8E6bpIrCOkCTPS4tjG7crZeZIuoQ//+yRwCAARBbAIAADPWAgABuHTA=
Date: Tue, 25 Sep 2012 03:04:57 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D1396@BGSMSX101.gar.corp.intel.com>
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
	 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
	 <1348477068.10877.180.camel@rui.sh.intel.com>
	 <50610504.7050706@samsung.com> <1348538339.10877.193.camel@rui.sh.intel.com>
In-Reply-To: <1348538339.10877.193.camel@rui.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8P36hrP024044

Hi Rui,

> > > Hi, Jonghwa,
> > >
> > > I still do not understand what the problem is.
> > > Say if a cooling device fails to bind, the thermal zone device would
> > > still work properly, just like the failure cooling device is not
> > > referenced in this thermal zone.
> > >
> > > thanks,
> > > rui
> > Hi rui,
> > No, it doesn't work properly. If it fails to bind some cool dev to
> > thermal zone device, it frees thermal zone
> > device without canceling delayed work. After freeing thermal zone
> > device, system may call work function
> > pointed NULL as the timer expired. Thus it requires skipping the
> > initialization of polling work or canceling before
> > the unregister.
> 
> 
> hah, I see what the problem is.
> ideally, if we fail to bind one cooling device, we should just ignore it
> and continue to bind other, what do you think?

Yes, this is what we should do.

> 
> does the patch below fix your problem?
> If yes, I'll try to rebase it on top of my next tree.

This is already fixed in your -next tree, since you applied the
fair share patches 10/15. The function bind_tz(tz) does the
exact same thing, and continues.

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
