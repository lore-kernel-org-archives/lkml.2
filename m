Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2LNT6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:58:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:32629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab2LNT6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:58:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,284,1355126400"; 
   d="scan'208";a="181047724"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gaowanlong@cn.fujitsu.com" <gaowanlong@cn.fujitsu.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>, Jerry Snitselaar <dev@snitselaar.org>
Subject: RE: kernel panic when reboot
Thread-Topic: kernel panic when reboot
Thread-Index: AQHN2eqxyCT5PTZOYUaongQnJsuHepgYKNcAgACLjDA=
Date: Fri, 14 Dec 2012 19:58:06 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EA74E4@HASMSX106.ger.corp.intel.com>
References: <50CAF165.5080209@cn.fujitsu.com>
 <20121214110253.GB4966@liondog.tnic> <50CB29D2.8040602@cn.fujitsu.com>
In-Reply-To: <50CB29D2.8040602@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBEJwODj002261

> 
> On 12/14/2012 07:02 PM, Borislav Petkov wrote:
> > On Fri, Dec 14, 2012 at 05:29:09PM +0800, Wanlong Gao wrote:
> >> Hi,
> >>
> >> I hit the kernel panic when reboot the system today, just system reboot
> can cause kernel panic.
> >>
> >> $ git describe
> >> v3.7-7784-g7313264
> >>
> >> The config file is attached.
> >> And the crash screen is uploaded here
> >> http://www.tiikoni.com/tis/view/?id=e187047
> >
> > AFAICT, it looks like list corruption in the mutex_lock path when
> > trying to grab the watchdog->lock, when we're coming down from
> > mei_watchdog_unregister().
> >
> > Is it reproducible?
> 
> It's panicked every time I reboot the system.
> 
Thanks for the report. The issue was introduced by commit: c7d3df3 as found by Jerry
The bug fix is on the way.
Thanks
Tomas

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
