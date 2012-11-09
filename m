Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2KILk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:40:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KILk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:40:58 -0500
Message-ID: <509CEB9F.8080705@kernel.dk>
Date: Fri, 09 Nov 2012 12:40:15 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
References: <3042269.jrNem7z1LI@fat-tyre>
In-Reply-To: <3042269.jrNem7z1LI@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 12:36, Philipp Reisner wrote:
> Hi Jens,
> 
> Please pull drbd-8.4.2 into your for-3.8/drivers branch.
> 
> The most noticeable change is the support for multiple replicated
> volumes in a single DRBD connection.
> 
> This release requires new drbd userland tools >= 8.4.0 (available
> since July 2011).
> 8.4.x is network protocol compatible with all previous releaes.
> This release brings a new meta-data format. Forward (8.3 -> 8.4)
> conversion happens complete seamless. Backward conversion
> is done by a single command (drbdadm apply-al res).
> 
> The "recent changes" chapter of our user's guide describes all
> changes in detail:
> http://www.drbd.org/users-guide/ap-recent-changes.html
> 
> Changelog
> 
> 8.4.2 (api:genl1/proto:86-100)
> --------
>  * Go into inconsistent disk state with on-io-error=pass-on policy
>  * Timeouts for requests processing on the peer (previously that
>    worked only if the data socket was congested)
>  * Conflicting write detection is now based on an interval tree,
>    removed the hash-tables (necessary for the unlimited BIO sizes)
>  * Support for multiple volumes (minors, block devices) per connection;
>    up to 65536 volumes per connection supported
>  * Reduced IO latencies during some state changes (esp. start resync)
>  * New on disk format for the AL: double capacity; 4k aligned IO; same space
>  * Multiple AL changes in a single transaction (precondition for
>    unlimited BIO sizes)
>  * DRBD no longer imposes any limit on BIO sizes
>  * Removed DRBD's limits on the number of minor devices
>  * DRBD's minors can now be removed (not only unconfigured)
>  * Switched the user space interface form connector to generic netlink
>  * The wire-protocol is now a regular connection option, which can be
>    changed while the device is online
>  * IO freezing/thawing is done on connection (all volumes) level
>  * fencing is done on connection (all volumes) level
>  * Enforce application of activity log after primary crash in user space
>  * New default values (compared to drbd-8.3) for: minor-count, ko-count, al-extents,
>    c-plan-ahead, c-fill-target, c-min-rate, use-rle, on-io-error
>  * Optional load balancing for read requests: new keyword "read-balance"
>  * New option 'al-updates no' to disable writing transactions into the
>    activity log. It is use full if you prefer a full sync after a primary
>    crash, for improved performance of a spread out random write work load
>  * Expose the data generation identifies via sysfs
> 
> 
> Jens, regarding the code:
> 
> It has the sysfs bits in again. The reason for that is that we want to
> expose more information by that, and remove the /proc/drbd with the
> next evolutionary step. -- In case this is a show stopper, let me
> remove the sysfs bits.

The exact same sysfs bits I complained about last time? If yes, then I
don't understand why you haven't changed yet. Or why you are trying to
push the same bits again that got rejected last time.

> Here is the git-pull-request test: 
> (The patch subjects removed to make the mail more digestible)

Please don't do that, it basically makes the pull request useless! A few
hundred extra lines is not an issue.


-- 
Jens Axboe

