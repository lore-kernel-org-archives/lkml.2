Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2EROWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:22:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:58188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2EROW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:22:29 -0400
Date: Fri, 18 May 2012 16:22:26 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
Message-ID: <20120518142226.GF6496@kernel.dk>
References: <4277851.LeAnKnANCB@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4277851.LeAnKnANCB@fat-tyre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2012, Philipp Reisner wrote:
> Hi Jens,
> 
> This are the updates we have in the drbd-8.3 tree. They are intended
> for your "for-3.5/drivers" drivers branch.
> 
> These changes include one new feature:
>  * Allow detach from frozen backing devices with the new --force option;
>    configurable timeout for backing devices by the new disk-timeout option
> 
> And huge number of bug fixes:
>  * Fixed a write ordering problem on SyncTarget nodes for a write
>    to a block that gets resynced at the same time. The bug can
>    only be triggered with a device that has a firmware that
>    actually reorders writes to the same block
>  * Fixed a race between disconnect and receive_state, that could cause
>    a IO lockup
>  * Fixed resend/resubmit for requests with disk or network timeout
>  * Make sure that hard state changed do not disturb the connection
>    establishing process (I.e. detach due to an IO error). When the
>    bug was triggered it caused a retry in the connect process
>  * Postpone soft state changes to no disturb the connection
>    establishing process (I.e. becoming primary). When the bug
>    was triggered it could cause both nodes going into SyncSource state
>  * Fixed a refcount leak that could cause failures when trying to
>    unload a protocol family modules, that was used by DRBD
>  * Dedicated page pool for meta data IOs
>  * Deny normal detach (as opposed to --forced) if the user tries
>    to detach from the last UpToDate disk in the resource
>  * Fixed a possible protocol error that could be caused by
>    "unusual" BIOs.
>  * Enforce the disk-timeout option also on meta-data IO operations
>  * Implemented stable bitmap pages when we do a full write out of
>    the bitmap
>  * Fixed a rare compatibility issue with DRBD's older than 8.3.7
>    when negotiating the bio_size
>  * Fixed a rare race condition where an empty resync could stall with
>    if pause/unpause events happen in parallel
>  * Made the re-establishing of connections quicker, if it got a broken pipe
>    once. Previously there was a bug in the code caused it to waste the first
>    successful established connection after a broken pipe event.
> 
> PS: I am postponing the drbd-8.4 for mainline for one or two kernel
>     development cycles more (the ~400 patchets set).
> 
> Best regards,
>  Philipp
> 
> The following changes since commit 0b7877d4eea3f93e3dd941999522bbd8c538cb53:
> 
>   Merge tag 'v3.4-rc5' into for-3.5/core (2012-05-01 14:29:55 +0200)
> 
> are available in the git repository at:
> 
>   git@git.drbd.org:linux-drbd for-jens

Thanks, pulled in. Your git url confused me a bit, though, I pulled in
git://git.drbd.org/linux-drbd for-jens

Diffstat matches etc, so I'm jotting the above down to a typo in your
pull request script.

-- 
Jens Axboe

