Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2HZOlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:41:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2HZOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:41:14 -0400
Message-ID: <503A3565.2060004@redhat.com>
Date: Sun, 26 Aug 2012 10:40:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v9 0/5] make balloon pages movable by compaction
References: <cover.1345869378.git.aquini@redhat.com> <20120826075840.GE19551@redhat.com>
In-Reply-To: <20120826075840.GE19551@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 03:58 AM, Michael S. Tsirkin wrote:
> On Sat, Aug 25, 2012 at 02:24:55AM -0300, Rafael Aquini wrote:
>> Memory fragmentation introduced by ballooning might reduce significantly
>> the number of 2MB contiguous memory blocks that can be used within a guest,
>> thus imposing performance penalties associated with the reduced number of
>> transparent huge pages that could be used by the guest workload.
>>
>> This patch-set follows the main idea discussed at 2012 LSFMMS session:
>> "Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/
>> to introduce the required changes to the virtio_balloon driver, as well as
>> the changes to the core compaction & migration bits, in order to make those
>> subsystems aware of ballooned pages and allow memory balloon pages become
>> movable within a guest, thus avoiding the aforementioned fragmentation issue
>
> Meta-question: are there any numbers showing gain from this patchset?
>
> The reason I ask, on migration we notify host about each page
> individually.  If this is rare maybe the patchset does not help much.
> If this is common we would be better off building up a list of multiple
> pages and passing them in one go.

The gain is in getting a better THP allocation rate inside the
guest, allowing applications to run faster.

The rarer it is for this code to run, the better - it means we
are getting the benefits without the overhead :)

-- 
All rights reversed
