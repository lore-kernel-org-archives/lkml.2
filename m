Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2CGHxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:53:52 -0500
Received: from smtp.nokia.com ([147.243.128.26]:23525 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab2CGHxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:53:50 -0500
From: <leonid.moiseichuk@nokia.com>
To: <anton.vorontsov@linaro.org>, <penberg@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <rientjes@google.com>
Subject: RE: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd() ABI
Thread-Topic: [PATCH] vmevent: Use 'struct vmevent_attr' for vmevent_fd() ABI
Thread-Index: AQHM+9rtc1p7iYFq9EKSvnKs9/HU65Zd0SKAgACkkMA=
Date: Wed, 7 Mar 2012 07:53:37 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904581EF7@008-AM1MPN1-003.mgdnok.nokia.com>
References: <1331067079-2163-1-git-send-email-penberg@kernel.org>
 <20120306225937.GA24931@oksana.dev.rtsoft.ru>
In-Reply-To: <20120306225937.GA24931@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.162.64.195]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Mar 2012 07:53:39.0664 (UTC) FILETIME=[68AF9500:01CCFC37]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q277rvnr013308

> -----Original Message-----
> From: ext Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: 07 March, 2012 01:00
> To: Pekka Enberg
> Cc: linux-kernel@vger.kernel.org; Moiseichuk Leonid (Nokia-MP/Espoo);
...
> Sorry for hijacking this thread, but speaking of big changes. Are there any
> plans or ideas to add other methods of sampling, i.e. something not timer-
> based?
...
> Though, current vmevent seems not so lightweigh in sense of battery usage
> and accuracy (i.e. how quick we're able to detect the crossed threshold). To
> get better accuracy we would need to run timer at higher frequencies, but
> then we would waste more battery.

One of patch I sent was about switching to deferred timer. This API should not be 100% accurate first, and using deferred
timers will allow to sleep properly when system has no activity. I hope Pekka will accept the next patch as well.

> 
> Sure, vmevent is still lightweight in sense that it does not cause much
> runtime overhead or memory wastage (unlike cgroups).

"Timer work" is really lightweight.

> 
> The only idea I have for vmevent is to make some hybrid: timer plus shrinker
> API. That way we would detect "low memory" events fast enough via
> shrinker API, and thus run timer at low freq.

I used the same, see post about memnotify. Shrinker roll timer to be triggered soon.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
