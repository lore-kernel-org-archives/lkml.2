Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2FHLD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 07:03:56 -0400
Received: from smtp.nokia.com ([147.243.1.48]:21304 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2FHLDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 07:03:55 -0400
From: <leonid.moiseichuk@nokia.com>
To: <cbouatmailru@gmail.com>
CC: <kosaki.motohiro@gmail.com>, <penberg@kernel.org>,
        <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>
Subject: RE: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Topic: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//7gqAgAAk2GD//+b9AIAAJPtQ///62gAABLpu8A==
Date: Fri, 8 Jun 2012 11:03:29 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7C35@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608075844.GA6362@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7A24@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608084105.GA9883@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7B01@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608103501.GA15827@lizard>
In-Reply-To: <20120608103501.GA15827@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.0.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 11:03:30.0090 (UTC) FILETIME=[565368A0:01CD4566]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q58B42ht025696

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: 08 June, 2012 13:35
...
> > Context switches, parsing, activity in userspace even memory situation is
> not changed.
> 
> Sure, there is some additional overhead. I'm just saying that it is not drastic. It
> would be like 100 sprintfs + 100 sscanfs + 2 context switches? Well, it is
> unfortunate... but come on, today's phones are running X11 and Java. :-)

Vmstat generation is not so trivial. Meminfo has even higher overhead. I just checked generation time using idling device and open/read test:
- vmstat min 30, avg 94 max 2746 uSeconds
- meminfo min 30, average 65 max 15961 uSeconds

In comparison /proc/version for the same conditions: min 30, average 41, max 1505 uSeconds
 
> > In kernel space you can use sliding timer (increasing interval) + shinker.
> 
> Well, w/ Minchan's idea, we can get shrinker notifications into the userland,
> so the sliding timer thing would be still possible.

Only as a post-schrinker actions. In case of memory stressing or close-to-stressing conditions shrinkers called very often, I saw up to 50 times per second.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
