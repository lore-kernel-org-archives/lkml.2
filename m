Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0D0JsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:48:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60776 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab0D0JsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:48:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fat: excessive log spamming due to corrupted fs
References: <20100422155944.GA22181@sig21.net>
Date: Tue, 27 Apr 2010 18:48:04 +0900
In-Reply-To: <20100422155944.GA22181@sig21.net> (Johannes Stezenbach's message
	of "Thu, 22 Apr 2010 17:59:44 +0200")
Message-ID: <87633d2pm3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach <js@sig21.net> writes:

> Mounting still worked but when accessing the new file the kernel
> log was filled up with
>
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
> Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel:    File system has been set read-only
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
> Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem error (dev sdb1)
> Apr 22 16:30:18 zzz kernel:    fat_get_cluster: invalid cluster chain (i_pos 34568)
> ...
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem error lidAT: Filesysalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fiesysalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fesystalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem alid cluster chain (i_pos 3AT: Fiesyalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos AT: Fiesystalid cluster chain (i_pos 34568)
> Apr 22 16:30:18 zzz kernel: FAT: Filesystealid cluster chain (i_pos 3AT: Fiesystalid cluster chain (i_pos 34568)
> ...
> (~10000 lines)
>
>
> It seems that fat_fs_error() generates corrupted output
> (on an Athlon 4850e dual core), and the excessive amounts
> of output are IMHO not useful.

It seems, userland or readahead or read directory entires didn't stop
with EIO (dir is intended though, to salvage as many files as
possible). I'll think about using the ratelimit for fs corruption
report.

I have no idea about message corruption, vfat just call vprintf() for
it. I'll see current vprintf() locking stuff.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
