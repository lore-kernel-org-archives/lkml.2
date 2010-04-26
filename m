Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0DZMnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:43:33 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:49537 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab0DZMnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:43:32 -0400
Message-ID: <4BD58A6C.6040104@linux.vnet.ibm.com>
Date: Mon, 26 Apr 2010 14:43:24 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, gregkh@novell.com,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: Subject: [PATCH][RFC] mm: make working set portion that is protected
 tunable v2
References: <20100322235053.GD9590@csn.ul.ie> <20100419214412.GB5336@cmpxchg.org>	 <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com> <4BCE7DD1.70900@linux.vnet.ibm.com>	 <4BCEAAC6.7070602@linux.vnet.ibm.com> <4BCEFB4C.1070206@redhat.com>	 <4BCFEAD0.4010708@linux.vnet.ibm.com> <4BD57213.7060207@linux.vnet.ibm.com> <p2y2f11576a1004260459jcaf79962p50e4d29f990019ee@mail.gmail.com>
In-Reply-To: <p2y2f11576a1004260459jcaf79962p50e4d29f990019ee@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



KOSAKI Motohiro wrote:
> Hi
> 
> I've quick reviewed your patch. but unfortunately I can't write my
> reviewed-by sign.

Not a problem, atm I'm happy about any review and comment :-)

>> Subject: [PATCH][RFC] mm: make working set portion that is protected tunable v2
>> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>>
>> *updates in v2*
>> - use do_div
>>
>> This patch creates a knob to help users that have workloads suffering from the
>> fix 1:1 active inactive ratio brought into the kernel by "56e49d21 vmscan:
>> evict use-once pages first".
>> It also provides the tuning mechanisms for other users that want an even bigger
>> working set to be protected.
> 
> We certainly need no knob. because typical desktop users use various
> application,
> various workload. then, the knob doesn't help them.

Briefly - We had discussed non desktop scenarios where like a day load 
that builds up the working set to 50% and a nightly backup job which 
then is unable to use that protected 50% when sequentially reading a lot 
of disks and due to that doesn't finish before morning.

The knob should help those people that know their system would suffer 
from this or similar cases to e.g. set the protected ratio smaller or 
even to zero if wanted.

As mentioned before, being able to gain back those protected 50% would 
be even better - if it can be done in a way not hurting the original 
intention of protecting them.

I personally just don't feel too good knowing that 50% of my memory 
might hang around unused for many hours while they could be of some use.
I absolutely agree with the old intention and see how the patch helped 
with the latency issue Elladan brought up in the past - but it just 
looks way too aggressive to protect it "forever" for some server use cases.

> Probably, I've missed previous discussion. I'm going to find your previous mail.

The discussion ends at http://lkml.org/lkml/2010/4/22/38 - feel free to 
click through it.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
