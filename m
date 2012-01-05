Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2AENDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:03:38 -0500
Received: from smtp.nokia.com ([147.243.128.26]:65250 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2AENDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:03:37 -0500
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>
CC: <gregkh@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <aarcange@redhat.com>, <riel@redhat.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX9o6HwgAAD5oCAABMyQA==
Date: Thu, 5 Jan 2012 13:02:23 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904554391@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
	<20120104195612.GB19181@suse.de>
	<84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
In-Reply-To: <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jan 2012 13:02:24.0641 (UTC) FILETIME=[44D23F10:01CCCBAA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, mm/notify.c seems a bit global for me. At the first step I handle inputs from Greg and try to find less destructive approach to allocation tracking rather than page_alloc.
The issue is I know quite well my problem, so other guys who needs memory tracking has own requirements how account memory, how often notify/which granularity,  
how  many clients could be and so one. If I get some inputs I will be happy to implement them.

With Best Wishes,
Leonid


-----Original Message-----
From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext Pekka Enberg
Sent: 05 January, 2012 14:41
To: Moiseichuk Leonid (Nokia-MP/Helsinki)
Cc: gregkh@suse.de; linux-mm@kvack.org; linux-kernel@vger.kernel.org; cesarb@cesarb.net; kamezawa.hiroyu@jp.fujitsu.com; emunson@mgebm.net; aarcange@redhat.com; riel@redhat.com; mel@csn.ul.ie; rientjes@google.com; dima@android.com; rebecca@android.com; san@google.com; akpm@linux-foundation.org; Jaaskelainen Vesa (Nokia-MP/Helsinki)
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related changes in MM

On Thu, Jan 5, 2012 at 1:47 PM,  <leonid.moiseichuk@nokia.com> wrote:
> As I understand AOOM it wait until situation is reached bad conditions 
> which required memory reclaiming, selects application according to 
> free memory and oom_adj level and kills it.  So no intermediate levels could be checked (e.g.
> 75% usage),  nothing could be done in user-space to prevent killing, 
> no notification for case when memory becomes OK.
>
> What I try to do is to get notification in any application that memory 
> becomes low, and do something about it like stop processing data, 
> close unused pages or correctly shuts applications, daemons.  
> Application(s) might have necessity to install several notification 
> levels, so reaction could be adjusted based on current utilization 
> level per each application, not globally.

Sure. However, from VM point of view, both have the exact same
functionality: detect when we reach low memory condition (for some configurable threshold) and notify userspace or kernel subsystem about it.

That's the part I'd like to see implemented in mm/notify.c or similar.
I really don't care what Android or any other folks use it for exactly as long as the generic code is light-weight, clean, and we can reasonably assume that distros can actually enable it.
