Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1H2Vt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:49:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab1H2Vt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:49:26 -0400
Date: Mon, 29 Aug 2011 14:48:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sjayaraman@suse.de
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] block: document blk-plug
Message-Id: <20110829144843.c8e9d397.akpm@linux-foundation.org>
In-Reply-To: <4E5B77D5.7090006@suse.de>
References: <4E5B77D5.7090006@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 16:58:21 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -863,17 +863,23 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
>  extern void blk_put_queue(struct request_queue *);
>  
>  /*
> + * blk_plug allows to build up a queue of related requests by holding the I/O
> + * fragments for a short period. This allows merging of sequential requests
> + * into single larger request. As the requests are moved from per-task list to
> + * the device's request_queue in a batch, this results in improved
> + * scalability as the lock contention for request_queue lock is reduced.
> + *
>   * Note: Code in between changing the blk_plug list/cb_list or element of such
>   * lists is preemptable, but such code can't do sleep (or be very careful),
>   * otherwise data is corrupted. For details, please check schedule() where
>   * blk_schedule_flush_plug() is called.

What does the older part of this comment mean?  If a code section is
preemptible then it *will* sleep.  That's what preemption does.

