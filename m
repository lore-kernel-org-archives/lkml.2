Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0D0LWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:22:04 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58725 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0D0LWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:22:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fat: excessive log spamming due to corrupted fs
References: <20100422155944.GA22181@sig21.net>
	<87633d2pm3.fsf@devron.myhome.or.jp>
	<20100427101423.GA30678@sig21.net>
Date: Tue, 27 Apr 2010 20:21:56 +0900
In-Reply-To: <20100427101423.GA30678@sig21.net> (Johannes Stezenbach's message
	of "Tue, 27 Apr 2010 12:14:23 +0200")
Message-ID: <87wrvt16p7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach <js@sig21.net> writes:

> On Tue, Apr 27, 2010 at 06:48:04PM +0900, OGAWA Hirofumi wrote:
>> Johannes Stezenbach <js@sig21.net> writes:
>> 
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem error lidAT: Filesysalid cluster chain (i_pos 34568)
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fiesysalid cluster chain (i_pos 34568)
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fesystalid cluster chain (i_pos 34568)
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem alid cluster chain (i_pos 3AT: Fiesyalid cluster chain (i_pos 34568)
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos AT: Fiesystalid cluster chain (i_pos 34568)
>> > Apr 22 16:30:18 zzz kernel: FAT: Filesystealid cluster chain (i_pos 3AT: Fiesystalid cluster chain (i_pos 34568)
>> 
>> I have no idea about message corruption, vfat just call vprintf() for
>> it. I'll see current vprintf() locking stuff.
>
> I think multiple printk per line is prone to corruption on SMP, see the
> comment about KERN_CONT in kernel.h.  But maybe it only happens
> for /var/log/kern.log and my xconsole when generating too much
> output too quickly, "dmesg -s 10000000 | less" did not show
> the corruption (but only shows ~2700 lines out of the ~10000).
> But I think fat should use vprintf() to a buffer and then one printk()
> instead of multiple printk + vprintk.

I think KERN_CONT issue doesn't explain this corruption (i.e. preempted
at middle of vprintk()), so even if this is one vprintk(), this will not
be fixed. One of possibility is buffer overflow of printk, so truncated
the message, but of course, I'm not sure at least for now, and I'm not
checking current printk stuff yet.

Thanks.

> In xconsole it looks like this:
>
> Apr 27 12:06:45 zzz kernel: <systerrouster chain (i_pos 34568)
> Apr 27 12:06:45 zzz kernel: <systeerroruster chain (i_pos 34568)
> Apr 27 12:06:45 zzz kernel: <systeerroruster chain (i_pos 34568)
> Apr 27 12:06:45 zzz kernel: <3systerroruster chain (i_pos 34568)
> Apr 27 12:06:45 zzz kernel: uster chain (i_pos 34568)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
