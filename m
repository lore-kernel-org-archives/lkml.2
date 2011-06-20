Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1FTBmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 21:42:23 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36573 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1FTBmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 21:42:21 -0400
Date: Sun, 19 Jun 2011 21:42:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: halfdog <me@halfdog.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: Can someone confirm ext4 BUG_ON on latest kernel build?
Message-ID: <20110620014219.GA32133@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, halfdog <me@halfdog.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <4DFDCBE0.5020806@halfdog.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFDCBE0.5020806@halfdog.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 10:13:52AM +0000, halfdog wrote:
> 
> Sorry, I do not have latest kernel. Can someone confirm this on latest?
> At least bugtracker does not know about it, and to my understanding of
> source, should be still here.
> 
> dd if=/dev/zero bs=1M count=64 of=test
> mkfs.ext4 -F test
> echo -n " " | dd of=test bs=1 count=1 seek=297195 conv=notrunc
> mount -o loop test /mnt/test
> dmesg -c
> 
> On ubuntu natty with latest kernel, it seems, that
> fs/ext4/super.c:__save_error_info calls mod_timer before timer->function
> is set at end of fs/ext4/super.c:ext4_fill_super via
>   sbi->s_err_report.function = print_daily_error_info;
> 
> This causes BUG_ON(!timer->function) in kernel/timer.c:__mod_timer
> Device is stuck, not usable any more.

This problem is fixed in 2.6.39 (via commit 0449641130f5, which landed
in mainline in 2.6.39-rc3).

Regards,

					- Ted
