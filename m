Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2E1KWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:22:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2E1KWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:22:21 -0400
Date: Mon, 28 May 2012 19:22:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] block: Mitigate lock unbalance caused by lock
 disconnect
Message-ID: <20120528102214.GB15202@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
 <1338171603-14393-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338171603-14393-1-git-send-email-asias@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 10:20:03AM +0800, Asias He wrote:
> Commit 777eb1bf15b8532c396821774bf6451e563438f5 disconnects externally
> supplied queue_lock before blk_drain_queue(). This would introduce lock
> unbalance because theads which have taken the external lock might unlock
> the internal lock in the during the queue drain.
> 
> This patch mitigate this by disconnecting the lock after the queue
> draining since queue draining makes a lot of request_queue users go
> away.

Can you please point out how the code is broken and that the code is
still broken after the patch but somewhat less likely to actually
fail?

Thanks.

-- 
tejun
