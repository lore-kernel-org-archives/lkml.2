Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0LQOXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:23:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0LQOXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:23:08 -0500
Message-ID: <4D0B71DF.9080804@redhat.com>
Date: Fri, 17 Dec 2010 09:21:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: skip balance_dirty_pages() for in-memory fs
References: <20101213144646.341970461@intel.com> <20101213150329.002158963@intel.com> <20101217021934.GA9525@localhost> <alpine.LSU.2.00.1012162239270.23229@sister.anvils> <20101217112111.GA8323@localhost>
In-Reply-To: <20101217112111.GA8323@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 06:21 AM, Wu Fengguang wrote:
> This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.
>
> It also prevents
>
> [  388.126563] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
>
> in the balance_dirty_pages tracepoint, which will call
>
> 	dev_name(mapping->backing_dev_info->dev)
>
> but shmem_backing_dev_info.dev is NULL.
>
> CC: Hugh Dickins<hughd@google.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
