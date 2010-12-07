Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0LGRfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:35:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0LGRfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:35:14 -0500
Message-ID: <4CFE7015.3070000@redhat.com>
Date: Tue, 07 Dec 2010 12:34:13 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: safety margin for bdi stat errors
References: <20101205064430.GA15027@localhost> <4CFB9BE1.3030902@redhat.com> <20101207131136.GA20366@localhost>
In-Reply-To: <20101207131136.GA20366@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 08:11 AM, Wu Fengguang wrote:

> So the root cause is, the bdi_dirty is well under nr_dirty due to
> accounting errors. They should be very close because there is only one
> heavy dirtied bdi in the system. This can be fixed by using
> bdi_stat_sum(), however that's costly on large NUMA machines. So do a
> less costly fix of lowering the bdi limit, so that the accounting
> errors won't lead to the absurd situation "global limit exceeded but
> bdi limit not exceeded".
>
> CC: Rik van Riel<riel@redhat.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

I like this simple approach.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
