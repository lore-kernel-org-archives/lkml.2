Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0KDIml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:42:41 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:52433 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0KDImi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:42:38 -0400
Date: Thu, 4 Nov 2010 04:41:12 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Adam Litke <agl@us.ibm.com>,
        Avi Kivity <avi@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <2080208615.1392881288860072684.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <690735095.1385111288840247360.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 00 of 66] Transparent Hugepage Support #32
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank Andrea for pointing out to me there are ongoing works for KSM and THP integration. Sorry for the noise.

CAI Qian

----- caiqian@redhat.com wrote:

> There were some changes of behaviours with THP and KSM statistics
> demonstrated by this program, http://people.redhat.com/qcai/ksm01.c.
> 
> There are 3 programs (A, B ,C) to allocate 128M memory each using KSM.
> A has memory content = 'c'.
> B has memory content = 'a'.
> C has memory content = 'a'.
> Then without THP,
> pages_shared = 2
> pages_sharing = 98285
> pages_sharing = 98292
> pages_unshared = 0
> pages_volatile = 17
> pages_to_scan = 98304
> sleep_millisecs = 0
> with THP,
> pages_shared is 2.
> pages_sharing is 18422.
> pages_unshared is 0.
> pages_volatile is 8.
> 
> Later,
> A has memory content = 'c'
> B has memory content = 'b'
> C has memory content = 'a'.
> Then without THP,
> pages_shared = 3
> pages_sharing = 98296
> pages_unshared = 0
> pages_volatile = 5
> with THP,
> pages_shared = 3
> pages_sharing = 16358
> pages_unshared = 0
> pages_volatile = 23
> 
> Later,
> A has memory content = 'd'
> B has memory content = 'd'
> C has memory content = 'd'
> Then without THP,
> pages_shared = 1
> pages_sharing = 98274
> pages_unshared = 0
> pages_volatile = 29
> with THP,
> pages_shared = 1
> pages_sharing = 8668
> pages_unshared = 0
> pages_volatile = 35
> 
> Finally,
> A changes one page to 'e'
> Then without THP,
> pages_shared = 1
> pages_sharing = 98274
> pages_unshared = 1
> pages_volatile = 28
> with THP,
> pages_shared = 1
> pages_sharing = 8163
> pages_unshared = 1
> pages_volatile = 27
> 
> Are those differences for pages_sharing between with and without THP
> are expected?
> 
> CAI Qian
