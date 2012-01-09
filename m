Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2AII3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:29:14 -0500
Received: from smtp.nokia.com ([147.243.128.24]:58970 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2AII3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:29:13 -0500
From: <leonid.moiseichuk@nokia.com>
To: <rientjes@google.com>
CC: <gregkh@suse.de>, <penberg@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <emunson@mgebm.net>,
        <aarcange@redhat.com>, <riel@redhat.com>, <mel@csn.ul.ie>,
        <dima@android.com>, <rebecca@android.com>, <san@google.com>,
        <akpm@linux-foundation.org>, <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX9o6HwgAAD5oCAABMyQIAAExqAgAAjOZCAAGZTgIAFYOgw
Date: Mon, 9 Jan 2012 08:27:52 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045549DF@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB9826904554391@008-AM1MPN1-003.mgdnok.nokia.com>
 <20120105145753.GA3937@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045545E5@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201051503530.10521@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201051503530.10521@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jan 2012 08:28:11.0496 (UTC) FILETIME=[9FA28E80:01CCCEA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 06 January, 2012 01:10

> If you can accept the overhead of the memory controller (increase in
> kernel text size and amount of metadata for page_cgroup), then you can
> already do this with a combination of memory thresholds with
> cgroup.event_control and disabling of the oom killer entirely with
> memory.oom_control.  You can also get notified when the oom killer is
> triggered by using eventfd(2) on memory.oom_control even though it's
> disabled in the kernel.  Then, the userspace task attached to that control
> file can send signals to applications to free their memory or, in the
> worst case, choose to kill an application but have all that policy be
> implemented in userspace.

We invested in memcg notification (Kiryl Shutsemau's patches) and use the similar approach in n9 already (see libmemnotifyqt on gitorious).
Unfortunately it is produces number of side effects which are related how memcg handled application injection/removal from/to group.
So I like to try another approach.

> We actually have extended that internally to have an oom killer delay,
> i.e. a specific amount of time must pass for userspace to react to the oom
...
> handled the event").  Those patches were posted on linux-mm several
> months
> ago but never merged upstream.  You should be able to use the same
> concept
> apart from the memory controller and implement it generically.

Yep. But in n9 concept OOMing some application is acceptable, so I do not see such changes as very suitable.

> You also presented this as an alternative for "embedded or small" users so
> I wasn't aware that using the memory controller was an acceptable solution
> given its overhead.

Overhead, by the way, fully acceptable and I think in never kernels (3.x) situation will be much better.
But memcg has from my point principal problems for case when you cgroup application set is updated when application foregrounded/backgrounded, unfortunately that is how n900 and n9 software designed.

Best Wishes,
Leonid
