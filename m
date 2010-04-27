Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0D0KO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:14:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:41548 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D0KO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:14:26 -0400
Date: Tue, 27 Apr 2010 12:14:23 +0200
From: Johannes Stezenbach <js@sig21.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fat: excessive log spamming due to corrupted fs
Message-ID: <20100427101423.GA30678@sig21.net>
References: <20100422155944.GA22181@sig21.net>
 <87633d2pm3.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87633d2pm3.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.731,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 06:48:04PM +0900, OGAWA Hirofumi wrote:
> Johannes Stezenbach <js@sig21.net> writes:
> 
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem error lidAT: Filesysalid cluster chain (i_pos 34568)
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fiesysalid cluster chain (i_pos 34568)
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos 3AT: Fesystalid cluster chain (i_pos 34568)
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem alid cluster chain (i_pos 3AT: Fiesyalid cluster chain (i_pos 34568)
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystem ealid cluster chain (i_pos AT: Fiesystalid cluster chain (i_pos 34568)
> > Apr 22 16:30:18 zzz kernel: FAT: Filesystealid cluster chain (i_pos 3AT: Fiesystalid cluster chain (i_pos 34568)
> 
> I have no idea about message corruption, vfat just call vprintf() for
> it. I'll see current vprintf() locking stuff.

I think multiple printk per line is prone to corruption on SMP, see the
comment about KERN_CONT in kernel.h.  But maybe it only happens
for /var/log/kern.log and my xconsole when generating too much
output too quickly, "dmesg -s 10000000 | less" did not show
the corruption (but only shows ~2700 lines out of the ~10000).
But I think fat should use vprintf() to a buffer and then one printk()
instead of multiple printk + vprintk.

In xconsole it looks like this:

Apr 27 12:06:45 zzz kernel: <systerrouster chain (i_pos 34568)
Apr 27 12:06:45 zzz kernel: <systeerroruster chain (i_pos 34568)
Apr 27 12:06:45 zzz kernel: <systeerroruster chain (i_pos 34568)
Apr 27 12:06:45 zzz kernel: <3systerroruster chain (i_pos 34568)
Apr 27 12:06:45 zzz kernel: uster chain (i_pos 34568)


Thanks
Johannes
