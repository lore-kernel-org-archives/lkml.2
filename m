Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2EAVPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:15:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2EAVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:15:13 -0400
Message-ID: <4FA05251.5060105@redhat.com>
Date: Tue, 01 May 2012 17:14:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm + fs: prepare for non-page entries in page cache
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <1335861713-4573-3-git-send-email-hannes@cmpxchg.org> <20120501120246.83d2ce28.akpm@linux-foundation.org> <20120501201504.GB2112@cmpxchg.org> <20120501132449.30485966.akpm@linux-foundation.org>
In-Reply-To: <20120501132449.30485966.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 04:24 PM, Andrew Morton wrote:

> That's a pretty significant alteration in the meaning of ->nrpages.
> Did this not have any other effects?

 From what I see (though it's been a long day), ->nrpages
stays the same it is now.

The non-page entries are simply not counted in ->nrpages.

> What does truncate do?  I assume it invalidates shadow page entries in
> the radix tree?  And frees the radix-tree nodes?

Indeed, truncate will get rid of the non-page entries
in the radix tree.  That is why it needs to be called
even if ->nrpages==0.

-- 
All rights reversed
