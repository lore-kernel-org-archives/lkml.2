Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2AMJfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:35:42 -0500
Received: from smtp.nokia.com ([147.243.1.48]:24242 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab2AMJfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:35:40 -0500
From: <leonid.moiseichuk@nokia.com>
To: <rientjes@google.com>
CC: <gregkh@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <penberg@kernel.org>, <aarcange@redhat.com>,
        <riel@redhat.com>, <mel@csn.ul.ie>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Topic: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Index: AQHMyxrzw3V52zxEQkmaiNpKEK9QnpYDzM3g///5tgCAABJ9kIAAofQAgAKqrWCAAIfZAIAAwQMggADDYwCAAOLXsA==
Date: Fri, 13 Jan 2012 09:34:40 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904557417@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195521.GA19181@suse.de>
 <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB98269045568A1@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201111338320.21755@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904556CB7@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201121247480.17287@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201121247480.17287@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.23.130]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Jan 2012 09:34:41.0440 (UTC) FILETIME=[937AB200:01CCD1D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 12 January, 2012 21:55
> To: Moiseichuk Leonid (Nokia-MP/Helsinki)
....
> 
> Then it's fundamentally flawed since there's no guarantee that coming with
> 100MB of the min watermark, for example, means that an oom is imminent
> and will just result in unnecessary notification to userspace that will cause
> some action to be taken that may not be necessary.  If the setting of these
> thresholds depends on some pattern that is guaranteed to be along the path
> to oom for a certain workload, then that will also change depending on VM
> implementation changes, kernel versions, other applications, etc., and simply
> is unmaintainable.

Why? That is expected that product tested and tuned properly, applications fixed, and at least no apps installed which might consume 100 MB in second or two.
If you have another product with big difference in memory size, applications etc. you might need to re-calibrate reactions.
Let's focus on realistic cases.

> It would be much better to address the slowdown when running out of
> memory rather than requiring userspace to react and unnecessarily send
> signals to threads that may or may not have the ability to respond because
> they may already be oom themselves.

That is not possible - signals usually set at level you have 20-50 MB to react. 
Slowdown is natural thing if you have lack of space for code paging, I do not see any ways to fix it.

>  You can do crazy things to reduce
> latency in lowmem memory allocations like changing gfp_allowed_mask to
> be GFP_ATOMIC so that direct reclaim is never called, for example, and then
> use the proposed oom killer delay to handle the situation at the time of oom.

It is not necessary.

> Regardless, you should be addressing the slowness in lowmem situations
> rather than implementing notifiers to userspace to handle the events itself,
> so nack on this proposal.

Define "lowmem situation" first.  For proposed approach it is from 50-90% of memory usage until user-space can do something.
