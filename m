Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2ALIdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:33:15 -0500
Received: from smtp.nokia.com ([147.243.1.48]:35028 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab2ALIdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:33:14 -0500
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
Thread-Index: AQHMyxrzw3V52zxEQkmaiNpKEK9QnpYDzM3g///5tgCAABJ9kIAAofQAgAKqrWCAAIfZAIAAwQMg
Date: Thu, 12 Jan 2012 08:32:16 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904556CB7@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195521.GA19181@suse.de>
 <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB98269045568A1@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201111338320.21755@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201111338320.21755@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.30.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Jan 2012 08:32:18.0499 (UTC) FILETIME=[B2197930:01CCD104]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 11 January, 2012 22:45
 
> I think you're misunderstanding the proposal; in the case of a global oom
> (that means without memcg) then, by definition, all threads that are
> allocating memory would be frozen and incur the delay at the point they
> would currently call into the oom killer.  If your userspace is alive, i.e. the
> application responsible for managing oom killing, then it can wait on
> eventfd(2), wake up, and then send SIGTERM and SIGKILL to the appropriate
> threads based on priority.
> 
> So, again, why wouldn't this work for you?

As I wrote the proposed change is not safety belt but looking ahead radar.
If it detects that we are close to wall it starts to alarm and alarm volume is proportional to distance.

In close-to-OOM situations device becomes very slow, which is not good for user. The performance difference depends on code size and storage performance 
to trash code pages but even 20% is noticeable. Practically 2x-5x times slowdown was observed.

We can do some actions ahead of time and try to prevent OOM at all like shrink caches in applications, close unused apps etc.  If OOM still happened due to 
3rd party components or misbehaving software even default OOM killer works good enough if oom_score_adj values are properly set.

Thus, controlling device on wider set of memory situations looks for me more beneficial than trying to  recover when situation is bad. And increasing complexity
of recovery mechanism (OOM, Android OOM, OOM with delay), involving user-space into decision-making, makes recovery _potentially_ less predictable.

Best Wishes,
Leonid

