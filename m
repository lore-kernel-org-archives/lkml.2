Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab1GOTTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:19:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab1GOTTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:19:40 -0400
Date: Fri, 15 Jul 2011 12:19:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Ayan George <ayan@ayan.net>, linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
Message-Id: <20110715121903.dc543613.akpm@linux-foundation.org>
In-Reply-To: <4E209132.7000704@cfl.rr.com>
References: <4E1F3BE0.8040506@ayan.net>
	<4E209132.7000704@cfl.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011 15:12:50 -0400
Phillip Susi <psusi@cfl.rr.com> wrote:

> On 7/14/2011 2:56 PM, Ayan George wrote:
> >
> > Hi Philip,
> >
> > This is the patch I'd like to submit for the loop device. I'm in the
> > process of testing it now. I'm pretty confident it will work.
>
> Looks good to me.  Forwarding to Andrew Morton.  Andrew, please 
> disregard my previous patch as I think this one is better.

Would prefer to wait until Ayan has completed testing it.  It would be
good if you were to test it too please.
 
> 
> [0001-Always-invalidate-cleared-loop-block-devices.patch  text/x-patch (2.9KB)]
> >From c783ba6a26eff42d3cb0061e4fcb8ee8a16b3e67 Mon Sep 17 00:00:00 2001
> From: Ayan George <ayan.george@canonical.com>
> Date: Thu, 14 Jul 2011 14:16:58 -0400
> Subject: [PATCH] Always invalidate cleared loop block devices
> 
> The API for loop_clr_fd() is confusing -- the second argument (bdev)
> isn't necessesary as struct loop_device contains a pointer to the block
> device it is assocated with.
> 
> There is a cases where loop_clr_fd() is called with NULL for bdev
> which prevents the block device from ever being invalidated with
> invalidate_bdev() and prevents a uevent from being emitted.
> 
> This patch removes the bdev argument from loop_clr_fd(), unconditionally
> invalidates lo->lo_device when cleared, and unconditionally emits a
> uevent for removed loops.

The patch appears to do two unrelated things.  That's generally frowned
upon, but doesn't bother me much if the patch is small.

Still, splitting it into two patches (in which the bugfix is staged
first) would be advantageous for people who might wish to backport the
fix into earlier kernels.

