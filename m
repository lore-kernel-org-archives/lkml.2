Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2AQO3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:29:38 -0500
Received: from smtp.nokia.com ([147.243.128.24]:32025 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab2AQO3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:29:36 -0500
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <emunson@mgebm.net>,
        <aarcange@redhat.com>, <riel@redhat.com>, <mel@csn.ul.ie>,
        <rientjes@google.com>, <dima@android.com>, <gregkh@suse.de>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH v2 2/2] Memory notification pseudo-device module
Thread-Topic: [PATCH v2 2/2] Memory notification pseudo-device module
Thread-Index: AQHM1Rx+OvEMeHtKAEm6KWeO1Y1MiJYQkA4w///1OgCAABKHwA==
Date: Tue, 17 Jan 2012 14:28:28 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045593DE@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
	<5b429d6c4d0a3ad06ec01193eab7edc98a03e0de.1326803859.git.leonid.moiseichuk@nokia.com>
	<CAOJsxLFCbF8azY48_SHhYQ0oRDrf2-rEvGMKHBne2Znpj0XL4g@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB9826904559397@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEtuzEYVUtukrA1JeJnuOJ6OsOHOj=j2gs=-0NHYVPzLQ@mail.gmail.com>
In-Reply-To: <CAOJsxLEtuzEYVUtukrA1JeJnuOJ6OsOHOj=j2gs=-0NHYVPzLQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 Jan 2012 14:28:30.0124 (UTC) FILETIME=[48A566C0:01CCD524]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 17 January, 2012 15:59
...
> If you're serious about making this a generic thing, it must live in
> mm/mem_notify.c. No ifs or buts about it.
> I'm also not completely convinced we need to put memnotify policy in the
> kernel. Why can't we extend Minchan's patch to report the relevant
> numbers and let the userspace figure out when pressure is above some
> interesting threshold?

I do not insist to have it as a part mm, but if you have 1-2-3 items what should be done in this or Minchan's patch I can participate.
>From my point of view Minchan's patch is not ideal due to required:
1. depends on cgroups (at least as I see it from patch in shrink_mem_cgroup_zone()part)
2. reports only memory pressure based on relation in between free and file pages which is means by active file IO you may get lowmem 
3. swapping should not produce lowmem, but active swapping - must, is  it checked there?
+	if (nr[LRU_INACTIVE_ANON])
+		low_mem = true;
4. required changes in vmscan

I think, due to everyone based on his experience/working area profile has own understanding what is "low memory"  (or similar situation which needs to be tracked) 
it should be  some generic or extendable API, not like ON/OFF trigger for something happened inside VM. From another point of view it should not be too generic due 
to tasks could be solved using memcg, ionice, OOM killer or variations of soft-OOM-patches.



