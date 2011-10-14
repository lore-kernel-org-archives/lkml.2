Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab1JNWRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:17:50 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:45863 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1JNWRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:17:49 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Fri, 14 Oct 2011 18:16:57 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyJ6oAPC5pDCSZQRDqc2xMRcl3KdQA1HzjO
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747AC@USINDEVS02.corp.hds.com>
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
 <alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>
 <20111013143501.a59efa5c.kamezawa.hiroyu@jp.fujitsu.com>,<alpine.DEB.2.00.1110131351270.24853@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110131351270.24853@chino.kir.corp.google.com>
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
 definitions=main-1110140286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 04:55 PM, David Rientjes wrote:
> 
> Satoru was specifically talking about the VM using free memory for 
> pagecache,

Yes, because we can't stop increasing pagecache and it 
occupies RAM where some people want to keep free for bursty
memory requirement. Usually it works fine but sometimes like
my test case doesn't work well.

> so doing echo echo 1 > /proc/sys/vm/drop_caches can mitigate 
> that almost immediately.  

I know it and some admins use that kind of tuning. But is it
proper way? Should we exec the script like above periodically?
I believe that we should use it for debug only.

> I think the key to the discussion, though, is 
> that even the application doesn't know it's bursty memory behavior before 
> it happens and the kernel entering direct reclaim hurts latency-sensitive 
> applications.
>
> If there were a change to increase the space significantly between the 
> high and min watermark when min_free_kbytes changes, that would fix the 
> problem. 

Right. But min_free_kbytes changes both thresholds, foregroud reclaim
and background reclaim. I'd like to configure them separately like
dirty_bytes and dirty_background_bytes for flexibility.

> The problem is two-fold: that comes at a penalty for systems 
> or workloads that don't need to reclaim the additional memory, and it's 
> not clear how much space should exist between those watermarks.

The required size depends on a system architacture such as kernel,
applications, storage etc. and so admin who care the whole system
should configure it based on tests by his own risk.

Regards,
Satoru