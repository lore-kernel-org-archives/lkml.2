Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DOR1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:27:12 -0400
Received: from elvis.mu.org ([192.203.228.196]:58288 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab0DOR1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:27:10 -0400
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, suleiman@google.com
Message-Id: <85DB7083-8E78-4884-9E76-5BD803C530EF@freebsd.org>
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: Dave Chinner <david@fromorbit.com>
In-Reply-To: <20100415093214.GV2493@dastard>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if current is kswapd
Date: Thu, 15 Apr 2010 10:27:09 -0700
References: <20100415013436.GO2493@dastard> <20100415130212.D16E.A69D9226@jp.fujitsu.com> <20100415131106.D174.A69D9226@jp.fujitsu.com> <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org> <20100415093214.GV2493@dastard>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 15, 2010, at 2:32 AM, Dave Chinner wrote:

> On Thu, Apr 15, 2010 at 01:05:57AM -0700, Suleiman Souhlal wrote:
>>
>> On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
>>
>>> Now, vmscan pageout() is one of IO throuput degression source.
>>> Some IO workload makes very much order-0 allocation and reclaim
>>> and pageout's 4K IOs are making annoying lots seeks.
>>>
>>> At least, kswapd can avoid such pageout() because kswapd don't
>>> need to consider OOM-Killer situation. that's no risk.
>>>
>>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> What's your opinion on trying to cluster the writes done by pageout,
>> instead of not doing any paging out in kswapd?
>
> XFS already does this in ->writepage to try to minimise the impact
> of the way pageout issues IO. It helps, but it is still not as good
> as having all the writeback come from the flusher threads because
> it's still pretty much random IO.

Doesn't the randomness become irrelevant if you can cluster enough
pages?

> And, FWIW, it doesn't solve the stack usage problems, either. In
> fact, it will make them worse as write_one_page() puts another
> struct writeback_control on the stack...

Sorry, this patch was not meant to solve the stack usage problems.

-- Suleiman
