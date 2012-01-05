Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2AEMY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:24:56 -0500
Received: from smtp.nokia.com ([147.243.128.24]:23321 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab2AEMYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:24:55 -0500
From: <leonid.moiseichuk@nokia.com>
To: <riel@redhat.com>, <gregkh@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <emunson@mgebm.net>,
        <penberg@kernel.org>, <aarcange@redhat.com>, <mel@csn.ul.ie>,
        <rientjes@google.com>, <dima@android.com>, <rebecca@android.com>,
        <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>, <minchan@redhat.com>,
        <kosaki.motohiro@gmail.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX8lOUAgAEWtcA=
Date: Thu, 5 Jan 2012 12:22:51 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045542EB@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de> <4F04B3F0.6080103@redhat.com>
In-Reply-To: <4F04B3F0.6080103@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jan 2012 12:23:04.0751 (UTC) FILETIME=[C6379BF0:01CCCBA4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q05CP0VS019778

Hi,

We (small and embedded) needs some mechanism to notify userspace that memory consumption is going to be high to allow react properly and keep device fast and stable:  close big graphics, shuts something not used, stop processing data etc.  If we not able to do it in the right moment OOM killer starts to work and applications just disappears which is not nice for user in all cases. So the proposed code is not replacement of OOM killer at all but, yes, could be recognized as part of "cooperative-oom". 

Since n900 we tried to use memcg and notifications. Unfortunately memcg is not nice suitable to handling processes due to how memory is accounted: taking into account caches produce false-positive notifications plus stability issues which could be result of outdated 2.6.32 kernel e.g. unnecessary swapping overhead when big process moved from one group to another or even device hung.  

With Best Wishes,
Leonid


-----Original Message-----
From: ext Rik van Riel [mailto:riel@redhat.com] 
Sent: 04 January, 2012 22:18
To: Greg KH
Cc: Moiseichuk Leonid (Nokia-MP/Helsinki); linux-mm@kvack.org; linux-kernel@vger.kernel.org; cesarb@cesarb.net; kamezawa.hiroyu@jp.fujitsu.com; emunson@mgebm.net; penberg@kernel.org; aarcange@redhat.com; mel@csn.ul.ie; rientjes@google.com; dima@android.com; rebecca@android.com; san@google.com; akpm@linux-foundation.org; Jaaskelainen Vesa (Nokia-MP/Helsinki); Minchan Kim; KOSAKI Motohiro
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related changes in MM

On 01/04/2012 02:56 PM, Greg KH wrote:

> How does this compare with the lowmemorykiller.c driver from the 
> android developers that is currently in the linux-next tree?

Also, the low memory notification that Kosaki-san has worked on, and which Minchan is looking at now.

We seem to have many mechanisms under development, all aimed at similar goals. I believe it would be good to agree on one mechanism that could solve multiple of these goals at once, instead of sticking a handful of different partial solutions in the kernel...

Exactly what is the problem you are trying to solve?

--
All rights reversed
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
