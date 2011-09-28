Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1I1Ar3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:47:29 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52642
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1I1ArY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:47:24 -0400
Date: Wed, 28 Sep 2011 02:47:23 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
Message-ID: <20110928004722.GA27421@kernel.dk>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109221318.p8MDIXPP020015@pentland.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22 2011, Hannes Reinecke wrote:
> 
> A kernel crash is observed when a mounted ext3/ext4 filesystem
> is physically removed.
> The problem is that blk_cleanup_queue() frees up some resources
> eg by calling elevator_exit(), which are not checked for in
> normal operation.
> So we should rather move these calls to the destructor function
> blk_release_queue() as at that point all remaining references
> are gone.
> However, in doing so we have to ensure that any externally
> supplied queue_lock is disconnected as the driver might
> free up the lock after the call of blk_cleanup_queue(),

Do we have acks from the people who saw this oops, that this really does
fix it for them? I ask since this fix is vastly cleaner than the other
patch floating around, so I'd much rather pull this one in.

-- 
Jens Axboe

