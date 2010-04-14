Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0DNSwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:52:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35993 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab0DNSwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:52:44 -0400
Date: Wed, 14 Apr 2010 20:52:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: blk-timeout.c  ensure jiffies wrap is handled
	correctly in blk_rq_timed_out_timer
Message-ID: <20100414185242.GN27497@kernel.dk>
References: <1271242645.2132.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271242645.2132.22.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14 2010, Richard Kennedy wrote:
> blk_rq_timed_out_timer() relied on blk_add_timer() never returning a
> timer value of zero, but commit 7838c15b8dd18e78a523513749e5b54bda07b0cb
> removed the code that bumped this value when it was zero.
> Therefore when jiffies is near wrap we could get unlucky & not set the
> timeout value correctly.
> 
> This patch uses a flag to indicate that the timeout value was set and so
> handles jiffies wrap correctly, and it keeps all the logic in one
> function so should be easier to maintain in the future. 

Thanks applied, it also makes it a bit clearer.

-- 
Jens Axboe

