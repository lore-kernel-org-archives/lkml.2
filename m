Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab1JLXxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:53:06 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:56410 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1JLXxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:53:04 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Date: Wed, 12 Oct 2011 19:52:29 -0400
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Topic: [PATCH -v2 -mm] add extra free kbytes tunable
Thread-Index: AcyJMC9QC9gAI2vVQJW3pPylNWLosgACYkTg
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com>
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
In-Reply-To: <alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110120301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 06:41 PM, David Rientjes wrote:
> On Wed, 12 Oct 2011, Satoru Moriya wrote:
> 
> I think the point was that extra_free_kbytes needs to be tuned to 
> cover at least the amount of memory of the largest allocation burst

Right. In enterprise area, we strictly test the system we build
again and again before we release it. In that situation, we can
set extra_free_kbytes appropriately based on system's requirements
and/or specifications etc.

> or it doesn't help to prevent latencies for rt threads and,

I thinks it also helps rt threads prevent latency as well as
normal threads because we can start kswapd earlier and avoid
direct reclaim.

> For example, if we were to merge Con's patch so kswapd operates at a 
> much higher priority for rt threads later on for another issue, it may 
> significantly reduce the need for extra_free_kbytes to be set as high 
> as it is.  Everybody who is setting this in init scripts, though, will 
> continue to set the value because they have no reason to believe it 
> should be changed.  Then, we have users who start to use the tunable 
> after Con's patch has been merged and now we have widely different 
> settings for the same tunable and it can never be obsoleted because 
> everybody is using it but for different historic reasons.
> 
> This is why I nack'd the patch originally: it will never be removed, 
> it is widely misunderstood, and is tied directly to the implementation 
> of reclaim which will change over time.

I understand what you concern. But in some area such as banking,
stock exchange, train/power/plant control sysemts etc this kind
of tunable is welcomed because they can tune their systems at
their own risk.

Also those systems have been used for a long time without significant
updating. If we update it or build a new system, we configure all
tunables from scratch.

Thanks,
Satoru
