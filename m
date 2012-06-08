Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab2FHI5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:57:46 -0400
Received: from smtp.nokia.com ([147.243.1.48]:16645 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab2FHI5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:57:44 -0400
From: <leonid.moiseichuk@nokia.com>
To: <anton.vorontsov@linaro.org>
CC: <kosaki.motohiro@gmail.com>, <penberg@kernel.org>,
        <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>
Subject: RE: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Topic: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//7gqAgAAk2GD//+b9AIAAJPtQ
Date: Fri, 8 Jun 2012 08:57:13 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7B01@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608075844.GA6362@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7A24@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608084105.GA9883@lizard>
In-Reply-To: <20120608084105.GA9883@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.0.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 08:57:15.0054 (UTC) FILETIME=[B340A4E0:01CD4554]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q588vphd025118

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: 08 June, 2012 11:41
...
> > Right. It but it has drawbacks as well e.g. ensure that daemon scheduled
> properly and propagate reaction decision outside ulmkd.
> 
> No, ulmkd itself propagates the decision (i.e. it kills processes).

That is a decision "select & kill" :)
Propagation of this decision required time. Not all processes could be killed. You may stuck in killing in some cases.
...
> In ulmkd I don't use timers at all, and by "watcher" I mean the some
> userspace daemon that receives lowmemory/pressure events (in our case it
> is ulmkd).

Thanks for info.

> If we start "polling" on /proc/vmstat via userland deferred timers, that would
> be a single timer, just like in vmevent case. So, I'm not sure what is the
> difference?..

Context switches, parsing, activity in userspace even memory situation is not changed. In kernel space you can use sliding timer (increasing interval) + shinker.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
