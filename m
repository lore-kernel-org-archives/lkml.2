Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1EZTIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:08:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51380 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317Ab1EZTIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:08:34 -0400
Message-ID: <4DDEA531.1040908@kernel.dk>
Date: Thu, 26 May 2011 21:08:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux@rainbow-software.org
Subject: Re: [PATCH] block: always allocate genhd->ev if check_events is 
 implemented
References: <20110525210656.GA18894@mtj.dyndns.org>
In-Reply-To: <20110525210656.GA18894@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 23:06, Tejun Heo wrote:
> 9fd097b149 (block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe
> drivers) removed DISK_EVENT_MEDIA_CHANGE from legacy/fringe block
> drivers which have inadequate ->check_events().  Combined with earlier
> change 7c88a168da (block: don't propagate unlisted DISK_EVENTs to
> userland), this enables using ->check_events() for internal processing
> while avoiding enabling in-kernel block event polling which can lead
> to infinite event loop.
> 
> Unfortunately, this made many drivers including floppy without any bit
> set in disk->events and ->async_events in which case disk_add_events()
> simply skipped allocation of disk->ev, which disables whole event
> handling.  As ->check_events() is still used during open processing
> for revalidation, this can lead to open failure.
> 
> This patch always allocates disk->ev if ->check_events is implemented.
> In the long term, it would make sense to simply include the event
> structure inline into genhd as it's now used by virtually all block
> devices.

Thanks, applied.

-- 
Jens Axboe

