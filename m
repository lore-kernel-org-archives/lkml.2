Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2AKMrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:47:31 -0500
Received: from smtp.nokia.com ([147.243.1.47]:20506 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2AKMr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:47:29 -0500
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
Thread-Index: AQHMyxrzw3V52zxEQkmaiNpKEK9QnpYDzM3g///5tgCAABJ9kIAAofQAgAKqrWA=
Date: Wed, 11 Jan 2012 12:46:33 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045568A1@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195521.GA19181@suse.de>
 <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.15.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Jan 2012 12:46:34.0896 (UTC) FILETIME=[0D352900:01CCD05F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 09 January, 2012 21:55
...
> 
> Maybe there's some confusion: the proposed oom killer delay that I'm
> referring to here is not upstream and has never been written for global oom
> conditions.  My reference to it earlier was as an internal patch that we carry
> on top of memory controller, but what I'm proposing here is for it to be
> implemented globally.

That is explains situation - I know how memcg can handle OOM in cgroup but not about internal patch.

> So if the page allocator can make no progress in freeing memory, we would
> introduce a delay in out_of_memory() if it were configured via a sysctl from
> userspace.  When this delay is started, applications waiting on this event can
> be notified with eventfd(2) that the delay has started and they have
> however many milliseconds to address the situation.  When they rewrite the
> sysctl, the delay is cleared.  If they don't rewrite the sysctl and the delay
> expires, the oom killer proceeds with killing.
> 
> What's missing for your use case with this proposal?

Timed delays in multi-process handling in case OOM looks for me fragile construction due to delays are not predicable.
Memcg supports [1] better approach to freeze whole group and kick pointed user-space application to handle it. We planned
to use it as:
- enlarge cgroup
- send SIGTERM to selected "bad" application e.g. based on oom_score
- wait a bit
- send SIGKILL to "bad" application
- reduce group size

But finally default OOM killer starts to work fine.

[1] http://lwn.net/Articles/377708/

 
