Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab2DKS42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:56:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2DKS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:56:27 -0400
Message-ID: <4F85C813.2050206@redhat.com>
Date: Wed, 11 Apr 2012 14:06:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Removal of lumpy reclaim V2
References: <1334162298-18942-1-git-send-email-mgorman@suse.de> <4F85BC8E.3020400@redhat.com> <20120411175215.GI3789@suse.de>
In-Reply-To: <20120411175215.GI3789@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:52 PM, Mel Gorman wrote:
> On Wed, Apr 11, 2012 at 01:17:02PM -0400, Rik van Riel wrote:

>> Next step: get rid of __GFP_NO_KSWAPD for THP, first
>> in the -mm kernel
>>
>
> Initially the flag was introduced because kswapd reclaimed too
> aggressively. One would like to believe that it would be less of a problem
> now but we must avoid a situation where the CPU and reclaim cost of kswapd
> exceeds the benefit of allocating a THP.

Since kswapd and the direct reclaim code now use
the same conditionals for calling compaction,
the cost ought to be identical.

I agree this is something we should shake out
in -mm for a while though, before considering a
mainline merge.

Andrew, would you be willing to take a removal
of __GFP_NO_KSWAPD in -mm, and push it to Linus
for the 3.6 kernel if no ill effects are seen
in -mm and -next?
