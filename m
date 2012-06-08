Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab2FHMZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:25:34 -0400
Received: from smtp.nokia.com ([147.243.1.47]:28929 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab2FHMZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:25:32 -0400
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
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//7gqAgAAk2GD//+b9AIAAJPtQ///62gAABLpu8P//9bUA///cm3A=
Date: Fri, 8 Jun 2012 12:25:11 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7D2B@008-AM1MPN1-004.mgdnok.nokia.com>
References: <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608075844.GA6362@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7A24@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608084105.GA9883@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7B01@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608103501.GA15827@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7C35@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608121334.GA20772@lizard>
In-Reply-To: <20120608121334.GA20772@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.0.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 12:25:12.0420 (UTC) FILETIME=[C0579A40:01CD4571]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q58CPdCY025995

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: 08 June, 2012 15:14
> To: Moiseichuk Leonid (Nokia-MP/Espoo)
...
> Hm. I would expect that avg value for meminfo will be much worse than
> vmstat (meminfo grabs some locks).
> 
> OK, if we consider 100ms interval, then this would be like 0.1% overhead?
> Not great, but still better than memcg:
> 
> http://lkml.org/lkml/2011/12/21/487

That is difficult to win over memcg :)
But in comparison to one syscall like read() for small structure for particular device the generation of meminfo is about 1000x times more expensive.

> So, I guess the right approach would be to find ways to not depend on
> frequent vm_stat updates (and thus reads).

Agree.

> userland deferred timers (and infrequent reads from vmstat) + "userland vm
> pressure notifications" looks promising for the userland solution.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
