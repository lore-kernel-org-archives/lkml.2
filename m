Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840Ab2FHIQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:16:39 -0400
Received: from smtp.nokia.com ([147.243.1.48]:34432 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab2FHIQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:16:28 -0400
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
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoP//7gqAgAAk2GA=
Date: Fri, 8 Jun 2012 08:16:04 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7A24@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
 <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <20120608075844.GA6362@lizard>
In-Reply-To: <20120608075844.GA6362@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.0.61]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 08:16:06.0070 (UTC) FILETIME=[F39F9560:01CD454E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q588Gqbe024883

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: 08 June, 2012 10:59
... 
> a) Two more context swtiches;
> b) Serialization/deserialization of /proc/vmstat.
> 
> > It also will cause page trashing because user-space code could be pushed
> out from cache if VM decide.
> 
> This can solved by moving a "watcher" to a separate (daemon) process, and
> mlocking it. We do this in ulmkd.

Right. It but it has drawbacks as well e.g. ensure that daemon scheduled properly and propagate reaction decision outside ulmkd.
Also I understand your statement about "watcher" as probably you use one timer for daemon. 
Btw, in my variant (memnotify.c) I used only one timer, it is enough.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
