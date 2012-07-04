Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2GDPGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:06:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:19966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab2GDPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="166895797"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Topic: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Index: AQHNWfRptMUUmgrTR0OSqLbmXZzgzpcYrxwAgACI/UA=
Date: Wed, 4 Jul 2012 15:06:06 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10CADD@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
	 <1341409177.2507.117.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10CA93@SHSMSX101.ccr.corp.intel.com>
	 <1341413431.2507.124.camel@laptop> <1341413521.2507.125.camel@laptop>
In-Reply-To: <1341413521.2507.125.camel@laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q64F6Gr0023593

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, July 04, 2012 10:52 PM
> To: Liu, Chuansheng
> Cc: 'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org); kay@vrfy.org;
> gregkh@linuxfoundation.org; mingo@elte.hu
> Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
> handle
> 
> On Wed, 2012-07-04 at 16:50 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-07-04 at 14:46 +0000, Liu, Chuansheng wrote:
> > > > > I took many time to dig out this issue.
> > > >
> > > > Well, it was a known issue..
> > > Still feel unfair :)
> > > If this is a known issue that calling printk is not safe in nmi
> > > handler, Why not defense it like this patch before real solution coming out?
> >
> > Why replace one broken thing with another broken thing?
> 
> Also, I much prefer obviously broken over subtly broken.
Supporting your opinion totally, but from production view, it is not a good thing that system crash,
I prefer to lose one log instead:)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
