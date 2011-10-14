Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1JNFdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:33:19 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:50471 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1JNFdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:33:17 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 14 Oct 2011 01:32:08 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyJagQkhSm7WT0YQw6oYzRPau78SQAyJl0F
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747AA@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
	<20111010153723.6397924f.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
	<20111011125419.2702b5dc.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
	<20111011135445.f580749b.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com>
	<alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com>
	<alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>,<20111013143501.a59efa5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111013143501.a59efa5c.kamezawa.hiroyu@jp.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110130396
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 01:35 AM, KAMEZAWA Hiroyuki wrote:
> 
> I don't read full story but....how about adding a new syscall like
> 
> ==
> sys_mem_shrink(int nid, int nr_scan_pages, int flags)
> 
> This system call scans LRU of specified nodes and free pages on LRU.
> This scan nr_scan_pages in LRU and returns the number of successfully
> freed pages.
> ==
> 
> Then, running this progam in SCHED_IDLE, a user can make free pages while
> the system is idle. If running in the highest priority, a user can keep
> free pages as he want. If a user run this under a memcg, user can free
> pages in a memcg. 

This is interesting. We can make userspace kswapd as we like with
this syscall. But it seems harder to be accepted...

Regards,
Satoru