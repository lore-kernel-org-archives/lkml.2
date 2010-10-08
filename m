Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0JHK1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:27:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:37133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab0JHK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:27:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="665400675"
From: "Wu, Xia" <xia.wu@intel.com>
To: "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
CC: Christoph Hellwig <hch@lst.de>, Yong Wang <yong.y.wang@linux.intel.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Fri, 8 Oct 2010 18:27:08 +0800
Subject: RE: [PATCH] bdi: use deferable timer for sync_supers task
Thread-Topic: [PATCH] bdi: use deferable timer for sync_supers task
Thread-Index: Actm0V2BNEu2xeyrTguHfKvnbO9zagAAMdNw
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
	 <20101008092520.GB5426@lst.de>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
 <1286532586.2095.55.camel@localhost>
In-Reply-To: <1286532586.2095.55.camel@localhost>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o98ARNd1002901


> On Fri, 2010-10-08 at 12:04 +0200, ext Wu, Xia wrote:
> > On Fri, Oct 08, 2010 at 04:35:14PM +0800, Yong Wang wrote:
> > > > sync_supers task currently wakes up periodically for superblock
> > > > writeback. This hurts power on battery driven devices. This patch
> > > > turns this housekeeping timer into a deferable timer so that it
> > > > does not fire when system is really idle.
> >
> > > How long can the timer be defereed?  We can't simply stop writing
> > > out data for a long time.  I think the current timer value should be
> > > the upper bound, but allowing to fire earlier to run during the
> > > same wakeup cycle as others is fine.
> >
> > If the system is in sleep state, this timer can be deferred to the next wake-up interrupt.
> > If the system is busy, this timer will fire at the scheduled time.

> However, when the next wake-up interrupt happens is not defined. It can
> happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
> says is that there should be some guarantee that sb writeout starts,
> say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
> this. But take a look at the range hrtimers - they do exactly this.

If the system is in sleep state, is there any data which should be written? Must 
sb writeout start even there isn't any data? 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
