Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0LEOFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:05:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab0LEOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:05:50 -0500
Message-ID: <4CFB9BE1.3030902@redhat.com>
Date: Sun, 05 Dec 2010 09:04:17 -0500
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
Subject: Re: [PATCH] writeback: enabling-gate for light dirtied bdi
References: <20101205064430.GA15027@localhost>
In-Reply-To: <20101205064430.GA15027@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 01:44 AM, Wu Fengguang wrote:
> I noticed that my NFSROOT test system goes slow responding when there
> is heavy dd to a local disk. Traces show that the NFSROOT's bdi_limit
> is near 0 and many tasks in the system are repeatedly stuck in
> balance_dirty_pages().
>
> There are two related problems:
>
> - light dirtiers at one device (more often than not the rootfs) get
>    heavily impacted by heavy dirtiers on another independent device
>
> - the light dirtied device does heavy throttling because bdi_limit=0,
>    and the heavy throttling may in turn withhold its bdi_limit in 0 as
>    it cannot dirty fast enough to grow up the bdi's proportional weight.
>
> Fix it by introducing some "low pass" gate, which is a small (<=8MB)
> value reserved by others and can be safely "stole" from the current
> global dirty margin.  It does not need to be big to help the bdi gain
> its initial weight.

Makes a lot of sense to me.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
