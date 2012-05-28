Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2E1AIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 20:08:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38307 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2E1AIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 20:08:01 -0400
Date: Mon, 28 May 2012 09:07:49 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix lock unbalance caused by lock disconnect
Message-ID: <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337911859-22913-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337911859-22913-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 10:10:59AM +0800, Asias He wrote:
> Commit 777eb1bf15b8532c396821774bf6451e563438f5 disconnects externally
> supplied queue_lock before blk_drain_queue(). This would introduce lock
> unbalance because theads which have taken the external lock might unlock
> the internal lock in the during the queue drain.
> 
> This patch fixes this by disconnecting the lock after the queue drain.

I don't think the patch description is correct.  The lock switcihng is
inherently broken and the patch doesn't really fix the problem
although it *might* make the problem less likely.  Trying to switch
locks while there are other accessors of the lock is simply broken, it
can never work without outer synchronization.  Your patch might make
the problem somewhat less likely simply because queue draining makes a
lot of request_queue users go away.

So, can you please update the commit description?  It doesn't really
*fix* anything but I think we're still better off with the change.

Thanks.

-- 
tejun
