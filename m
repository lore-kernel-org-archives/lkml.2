Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1IEPiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:38:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1IEPiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:38:15 -0400
Date: Mon, 5 Sep 2011 17:37:58 +0200
From: Jan Kara <jack@suse.cz>
To: martin f krafft <madduck@madduck.net>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Abysmal I/O scheduling with dm-crypt
Message-ID: <20110905153758.GJ5466@quack.suse.cz>
References: <20110830071407.GA8165@albatross.gern.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110830071407.GA8165@albatross.gern.madduck.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 30-08-11 09:14:07, martin f krafft wrote:
> for years I have been plagued by the following problem, and it is
> almost out of last resort that I am turning to you. I have searched
> the web over the months. There is talk of dirty_ratios, of caches,
> and of write throttling, but I have not been able to find a way to
> fix the problem.
> 
> I am using encrypted filesystems (dm-crypt) and the 3.0.0 kernel.
> Underneath might be a RAID1 or a fast SSD. On top is usually LVM
> with a few LVs holding the system.
> 
> Whenever an I/O-intensive task starts, such as:
> 
>   - tar -c or -x
>   - dd
>   - rsync
>   - notmuch
>   - …
> 
> the system becomes unusable for several seconds at a time, at least
> once or twice per minute. What seems to happen is that Vim or the
> Shell or Firefox or whatever else completely blocks, waiting for
> I/O, but Linux is not satisfying those I/O requests because it's
> busy servicing the aforementioned I/O-intensive task. As a result,
> Vim or the Shell or Firefox or whatever do not update, forcing me to
> wait for them to get an I/O service slot.
>
> People not running dm-crypt seem unable to reproduce this problem,
> making me think that it must be due to dm-crypt, and I wouldn't find
> it hard to imagine, because dm-crypt basically shields the
> I/O-scheduler of the kernel, doesn't it? Worse, it probably doesn't
> make any effort of scheduling I/O itself. Note: I know very little
> about the internals, so please correct me if I am wrong.
> 
> I am wondering if this is the case, and if so, what could be done
> about it.
  So as a start can you provide blktrace of all the relevant devices (i.e.
underlying SATA drive and dm-crypt device)? I.e. on my machine with
dm-crypt I'd run
  blktrace -d /dev/sda -d /dev/mapper/cr_sda3

  Also periodically getting list of blocked processes like
while true; do ps axl | grep " D"; echo "------"; usleep 100000; done
  might sched some light.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
