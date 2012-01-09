Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2AIIuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:50:40 -0500
Received: from smtp.nokia.com ([147.243.1.47]:16784 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2AIIuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:50:39 -0500
From: <leonid.moiseichuk@nokia.com>
To: <kosaki.motohiro@gmail.com>
CC: <gregkh@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <penberg@kernel.org>, <aarcange@redhat.com>,
        <riel@redhat.com>, <mel@csn.ul.ie>, <rientjes@google.com>,
        <dima@android.com>, <rebecca@android.com>, <san@google.com>,
        <akpm@linux-foundation.org>, <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX9o6HwgADJHQCABU5VQA==
Date: Mon, 9 Jan 2012 08:49:41 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904554A01@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
 <4F063FC0.8000907@gmail.com>
In-Reply-To: <4F063FC0.8000907@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jan 2012 08:49:43.0205 (UTC) FILETIME=[A18DB550:01CCCEAB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext KOSAKI Motohiro [mailto:kosaki.motohiro@gmail.com]
> Sent: 06 January, 2012 02:27
> To: Moiseichuk Leonid (Nokia-MP/Helsinki)
 
> > Android OOM (AOOM) is a different thing. Briefly Android OOM is a safety
> belt,
> >but I try to introduce look-ahead radar to stop before hitting wall.
> 
> You explained why we shouldn't merge neither you nor android notification
> patches.
> Many embedded developers tried to merge their own patch and claimed
> "Hey! my patch
> is completely different from another one". That said, their patches can't be
> used
> each other use case, just for them.

Pardon me but these patches doing really different thing. Having notification doesn't mean all you software will handle them correct. In open platform you might have "bad entity" which will be killed by OOM.
In we used default OOM killer but Android OOM probably works better in some other conditions even from my point of view it may trigger false OOMs due to base on NR_FREE_PAGES which are more interesting for kernel for than for user-space. 

> Systemwide global notification itself is not bad idea. But we definitely choose
> just one implementation. thus, you need to get agree with other embedded
> people.

Agree. That is point for discussion. One is already available through memcg but problem is in memcg and how we use it.

> >  UsedMemory = (MemTotal - MemFree - Buffers - Cached - SwapCached) +
> >                                               (SwapTotal - SwapFree)
> 
> If you spent a few time to read past discuttion, you should have understand
> your fomula
> is broken and unacceptable. Think, mlocked (or pinning by other way) cache
> can't be discarded. 

In theory you are right about mlocked pages.  So I will add deduction for NR_MLOCK
In practice typical desktop system has mlocked = 0. Also code pages are shared, so mlocking has 0 effect.
For data pages the some library like http://maemo.gitorious.org/maemo-tools/libmlocknice could be used.
Anyhow, on  n9 we have only  5.3 MB mlocked memory from 1024MB.

> And, When system is under swap thrashing, userland notification is useless.

Well, cgroups CPU shares and ionice seems to me better but as a quick solution extension with LRU_ACTIVE_ANON + LRU_ACTIVE_FILE could be done easily.

>  I don't think you tested w/ swap environment heavily.

n770, n800, n810 have optional in-file swapping.
n900 has permanent 768 MB swap partition.
n9 uses in-RAM lzo compressed 256 MB swap.

All of them tested, tuned and works fine for majority use-cases.

> While you are getting stuck to make nokia specific feature, I'm
> recommending you
> maintain your local patch yourself.

Thanks for advices, but I have better idea which is less destructive for MM.
Maybe it will more successful, at least for maintenance as a local patch.


