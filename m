Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2FHHIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:08:45 -0400
Received: from smtp.nokia.com ([147.243.1.48]:46186 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759440Ab2FHHIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:08:42 -0400
From: <leonid.moiseichuk@nokia.com>
To: <anton.vorontsov@linaro.org>, <kosaki.motohiro@gmail.com>,
        <penberg@kernel.org>
CC: <b.zolnierkie@samsung.com>, <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: RE: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Topic: [PATCH 2/5] vmevent: Convert from deferred timer to deferred
 work
Thread-Index: AQHNP/HM8KMmZkc4xkKq2ZDXaeCP2Zbvq0sAgAA7gACAACLOoA==
Date: Fri, 8 Jun 2012 07:05:46 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard>
In-Reply-To: <20120608065828.GA1515@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.162.61.214]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 07:05:47.0089 (UTC) FILETIME=[20EA2C10:01CD4545]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q58790wb024492

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: 08 June, 2012 09:58
...
> If you're saying that we should set up a timer in the userland and constantly
> read /proc/vmstat, then we will cause CPU wake up every 100ms, which is
> not acceptable. Well, we can try to introduce deferrable timers for the
> userspace. But then it would still add a lot more overhead for our task, as this
> solution adds other two context switches to read and parse /proc/vmstat. I
> guess this is not a show-stopper though, so we can discuss this.
> 
> Leonid, Pekka, what do you think about the idea?

Seems to me not nice solution. Generating/parsing vmstat every 100ms plus wakeups it is what exactly should be avoid to have sense to API.
It also will cause page trashing because user-space code could be pushed out from cache if VM decide. 

> 
> Thanks,
> 
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
