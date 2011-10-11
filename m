Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1JKTfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:35:42 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:46359 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1JKTfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:35:41 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
CC: Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Tue, 11 Oct 2011 15:32:11 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyHnTfmFReYnxFBTPGiWHi2BA2a6wAraVyg
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <20111010153723.6397924f.akpm@linux-foundation.org>
In-Reply-To: <20111010153723.6397924f.akpm@linux-foundation.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=34 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110110228
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 06:37 PM, Andrew Morton wrote:
> On Fri, 7 Oct 2011 20:08:19 -0700 (PDT) David Rientjes 
> <rientjes@google.com> wrote:
> 
>> On Thu, 1 Sep 2011, Rik van Riel wrote:
>
> The page allocator already tries harder if the caller has 
> rt_task(current).  Why is this inadequate?  Can we extend this idea 
> further to fix whatever-the-problem-is?

Actually page allocator decreases min watermark to 3/4 * min watermark
for rt-task. But in our case some applications create a lot of
processes and if all of them are rt-task, the amount of watermark
bonus(1/4 * min watermark) is not enough.

If we can tune the amount of bonus, it may be fine. But that is
almost all same as extra free kbytes.

> Does there exist anything like a test case which demonstrates the need 
> for this feature?

Unfortunately I don't have a real test case but just simple one.
And in my simple test case, I can avoid direct reclaim if we set
workload as rt-task.

The simple test case I used is following:
http://marc.info/?l=linux-mm&m=131605773321672&w=2

Regards,
Satoru
