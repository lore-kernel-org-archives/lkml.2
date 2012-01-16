Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2APGeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:34:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2APGeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:34:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120116055354.GA15265@localhost>
References: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
	<CAH+eYFB8xBPLJdN+jfqpESsqjkxdeRQD7oyfU8qHewzfmbqHow@mail.gmail.com>
	<20120115125853.GA9234@localhost>
	<20120115153838.GA4279@debian>
	<20120116025331.GA16516@localhost>
	<CAOAMb1Av0w8ip+YyMm82_U3n3zt8DDrofOmvKR+_5ikDMcbYmQ@mail.gmail.com>
	<20120116055044.GA14857@localhost>
	<20120116055354.GA15265@localhost>
Date: Mon, 16 Jan 2012 15:34:09 +0900
Message-ID: <CAOAMb1B7oENhPzgUkFjzuJ0==dnHRJkmHFSq-7QtSGeV6JeBvA@mail.gmail.com>
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is detached
From: Chanho Min <chanho0207@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rabin Vincent <rabin@rab.in>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But wait.. Rabin's patch actually fixes the NULL deference in
> the call
>
>        trace_writeback_wake_forker_thread(bdi);
>
> The wakeup of the forker thread should be harmless.
>
The forker thread shoud not be woken up after the bdi is unregistered.
Is this also Rabin's intention?
Also, I'm not sure the wakeup of the forker thread is harmless as bellows.
..
case FORK_THREAD:
..
  task = kthread_create(bdi_writeback_thread, &bdi->wb,
		      "flush-%s", dev_name(bdi->dev));

Thanks
Chanho
