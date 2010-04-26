Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0DZOVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0DZOVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:21:37 -0400
Message-ID: <4BD5A121.8060206@redhat.com>
Date: Mon, 26 Apr 2010 10:20:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, gregkh@novell.com,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: Subject: [PATCH][RFC] mm: make working set portion that is protected
 tunable v2
References: <20100322235053.GD9590@csn.ul.ie> <20100419214412.GB5336@cmpxchg.org>	 <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org> <4BCDE2F0.3010009@redhat.com> <4BCE7DD1.70900@linux.vnet.ibm.com>	 <4BCEAAC6.7070602@linux.vnet.ibm.com> <4BCEFB4C.1070206@redhat.com>	 <4BCFEAD0.4010708@linux.vnet.ibm.com> <4BD57213.7060207@linux.vnet.ibm.com> <p2y2f11576a1004260459jcaf79962p50e4d29f990019ee@mail.gmail.com> <4BD58A6C.6040104@linux.vnet.ibm.com>
In-Reply-To: <4BD58A6C.6040104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 08:43 AM, Christian Ehrhardt wrote:

>>> This patch creates a knob to help users that have workloads suffering
>>> from the
>>> fix 1:1 active inactive ratio brought into the kernel by "56e49d21
>>> vmscan:
>>> evict use-once pages first".
>>> It also provides the tuning mechanisms for other users that want an
>>> even bigger
>>> working set to be protected.
>>
>> We certainly need no knob. because typical desktop users use various
>> application,
>> various workload. then, the knob doesn't help them.
>
> Briefly - We had discussed non desktop scenarios where like a day load
> that builds up the working set to 50% and a nightly backup job which
> then is unable to use that protected 50% when sequentially reading a lot
> of disks and due to that doesn't finish before morning.

This is a red herring.  A backup touches all of the
data once, so it does not need a lot of page cache
and will not "not finish before morning" due to the
working set being protected.

You're going to have to come up with a more realistic
scenario than that.

> I personally just don't feel too good knowing that 50% of my memory
> might hang around unused for many hours while they could be of some use.
> I absolutely agree with the old intention and see how the patch helped
> with the latency issue Elladan brought up in the past - but it just
> looks way too aggressive to protect it "forever" for some server use cases.

So far we have seen exactly one workload where it helps
to reduce the size of the active file list, and that is
not due to any need for caching more inactive pages.

On the contrary, it is because ALL OF THE INACTIVE PAGES
are in flight to disk, all under IO at the same time.

Caching has absolutely nothing to do with the regression
you ran into.

