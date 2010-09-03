Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0ICS5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 14:57:24 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42716 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0ICS5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 14:57:23 -0400
Message-ID: <4C814514.4040103@kernel.dk>
Date: Fri, 03 Sep 2010 20:57:24 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: fuse-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ionice and FUSE-based filesystems?
References: <4C800B06.90005@genband.com>
In-Reply-To: <4C800B06.90005@genband.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 10:37 PM, Chris Friesen wrote:
> 
> I'm curious about the limits of using ionice with multiple layers of
> filesystems and devices.
> 
> In particular, we have a scenario with a FUSE-based filesystem running
> on top of xfs on top of LVM, on top of software RAID, on top of spinning
> disks.  (Something like that, anyways.)  The IO scheduler is CFQ.
> 
> In the above scenario would you expect the IO nice value of the writes
> done by a task to be propagated all the way down to the disk writes?  Or
> would they get stripped off at some point?

Miklos should be able to expand on what fuse does, but at least on
the write side priorities will only be carried through for non-buffered
writes with the current design (since actual write out happens out of
context of the submitting application).

-- 
Jens Axboe

