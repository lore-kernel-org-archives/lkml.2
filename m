Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1IXIcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 04:32:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1IXIcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:32:10 -0400
Date: Sat, 24 Sep 2011 09:32:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
Message-ID: <20110924083203.GZ17169@n2100.arm.linux.org.uk>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 04:03:15PM -0700, Simon Glass wrote:
> An accurate timer is required to make the numbers meaningful. Many
> modern platforms have a microsecond timer. This patch set uses a
> function called timer_get_us() to read the timer.

Not another 'get a time value' function.  Why do we need soo many?
We have - at least:

ktime_get (and various flavours of it)
do_gettimeofday
getnstimeofday
sched_clock

Do we really need yet another one which will have to be multiplexed
amongst platforms, requiring scaling and so forth from whatever the
platform provides?

Remember that ARM timers are virtually all MMIO mapped, which means
they don't work during early kernel bringup when the MMU mappings for
the hardware have not been setup.  (That's the reason stuff like
sched_clock for printk doesn't work early.)  That can't be solved by
creating yet another per-platform method to get microseconds.
