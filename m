Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1GAOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:19:06 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49511 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab1GAOTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:19:04 -0400
Message-ID: <4E0DD753.1090202@kernel.dk>
Date: Fri, 01 Jul 2011 16:18:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        linux-hotplug@vger.kernel.org
Subject: Re: [PATCH block:for-2.6.31/core] block: flush MEDIA_CHANGE from
 drivers  on close(2)
References: <20110630154822.GR3386@htj.dyndns.org>
In-Reply-To: <20110630154822.GR3386@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-30 17:48, Tejun Heo wrote:
> Currently, only open(2) is defined as the 'clearing' point.  It has
> two roles - first, it's an acknowledgement from userland indicating
> that the event has been received and kernel can clear pending states
> and proceed to generate more events.  Secondly, it's passed on to
> device drivers as a hint indicating that a synchronization point has
> been reached and it might want to take a deeper look at the device.
> 
> The latter currently is only used by sr which uses two different
> mechanisms - GET_EVENT_MEDIA_STATUS_NOTIFICATION and TEST_UNIT_READY
> to discover events, where the former is lighter weight and safe to be
> used repeatedly but may not provide full coverage.  Among other
> things, GET_EVENT can't detect media removal while TUR can.
> 
> This patch makes close(2) - blkdev_put() - indicate clearing hint for
> MEDIA_CHANGE to drivers.  disk_check_events() is renamed to
> disk_flush_events() and updated to take @mask for events to flush
> which is or'd to ev->clearing and will be passed to the driver on the
> next ->check_events() invocation.
> 
> This change makes sr generate MEDIA_CHANGE when media is ejected from
> userland - e.g. with eject(1).
> 
> Note: Given the current usage, it seems @clearing hint is needlessly
> complex.  disk_clear_events() can simply clear all events and the hint
> can be boolean @flush.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> ---
> Jens, this patch is for 3.1 merge window but generated on top of the
> current block:for-linus because it depends on the fixes in that
> branch.  It would probably be best to pull in for-linus into
> for-2.6.32/core before applying this patch.

Apart from some branch confusing in your email, I did that :-)
Applied, thanks.

-- 
Jens Axboe

