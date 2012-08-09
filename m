Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab2HIUbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab2HIUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:31:49 -0400
Message-ID: <50241DC5.7090704@redhat.com>
Date: Thu, 09 Aug 2012 16:29:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: vmscan: Scale number of pages reclaimed by reclaim/compaction
 based on failures
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-3-git-send-email-mgorman@suse.de> <20120808014824.GB4247@bbox> <20120808075526.GI29814@suse.de> <20120808082738.GF4247@bbox> <20120808085112.GJ29814@suse.de> <20120808235127.GA17835@bbox> <20120809074949.GA12690@suse.de> <20120809082715.GA19802@bbox> <20120809092035.GD12690@suse.de>
In-Reply-To: <20120809092035.GD12690@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 05:20 AM, Mel Gorman wrote:

> The intention is that an allocation can fail but each subsequent attempt will
> try harder until there is success. Each allocation request does a portion
> of the necessary work to spread the cost between multiple requests.

At some point we need to stop doing that work, though.

Otherwise we could end up back at the problem where
way too much memory gets evicted, and we get swap
storms.
