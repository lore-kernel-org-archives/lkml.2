Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2ATPE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:04:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33516 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2ATPEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:04:25 -0500
MIME-Version: 1.0
In-Reply-To: <20120120120801.GA22145@debian>
References: <20120116025331.GA16516@localhost>
	<1326991820-31393-1-git-send-email-rabin@rab.in>
	<CAKYAXd8poi6Rs7wyvZHre6qx-_i7eq0SBQAJNKNTYTLC5RQKjA@mail.gmail.com>
	<CAH+eYFBHTXVxdepno4xE-AxyYKqtNQHUvCY55z9_otN+25Y8Hg@mail.gmail.com>
	<CAKYAXd9M4wDi2tJDNjaDhHL9YapvXE71tGx_sh91DDpJNH+yKQ@mail.gmail.com>
	<20120120100309.GA20640@debian>
	<CAKYAXd8UuC0pAX7G7aG2q_3U_bPG8Bs_GpjxbfiX=9=Q+RW1Rg@mail.gmail.com>
	<20120120120801.GA22145@debian>
Date: Sat, 21 Jan 2012 00:04:23 +0900
Message-ID: <CAKYAXd-OzSsNgTakm_6Dq4p5C4KViBH6ctdXDO7tfkn=XrE8xA@mail.gmail.com>
Subject: Re: [PATCHv2] backing-dev: fix wakeup timer races with bdi_unregister()
From: Namjae Jeon <linkinjeon@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: fengguang.wu@intel.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        chanho0207@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> After this patch, this is what wakeup_timer_fn looks like:
>
> static void wakeup_timer_fn(unsigned long data)
> {
>        struct backing_dev_info *bdi = (struct backing_dev_info *)data;
>
>        spin_lock_bh(&bdi->wb_lock);
>        if (bdi->wb.task) {
>                trace_writeback_wake_thread(bdi);
>                wake_up_process(bdi->wb.task);
>        } else if (bdi->dev) {
>                /*
>                 * When bdi tasks are inactive for long time, they are killed.
>                 * In this case we have to wake-up the forker thread which
>                 * should create and run the bdi thread.
>                 */
>                trace_writeback_wake_forker_thread(bdi);
>                wake_up_process(default_backing_dev_info.wb.task);
>        }
>        spin_unlock_bh(&bdi->wb_lock);
> }
>
> So how will trace_writeback_wake_forker_thread() be called if bdi->dev is NULL?
>
> This patch added the if (bdi->dev) check, perhaps you overlooked that?

Hi Rabin.
I clearly understand. Thanks for your explanation.

Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
