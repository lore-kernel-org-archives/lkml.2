Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0KEMsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:48:25 -0400
Received: from excas01.olin.edu ([209.94.128.49]:5322 "EHLO EXCAS01.olin.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0KEMsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:48:23 -0400
Message-ID: <E1PELiI-0001Pj-8g@approx.mit.edu>
To: Dave Chinner <david@fromorbit.com>
CC: Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
In-Reply-To: Your message of "Fri, 05 Nov 2010 12:43:34 +1100."
             <20101105014334.GF13830@dastard>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Fri, 5 Nov 2010 08:48:13 -0400
From: Sanjoy Mahajan <sanjoy@olin.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:

> I think anyone reporting a interactivity problem also needs to
> indicate what their filesystem is, what mount paramters they are
> using, what their storage config is, whether barriers are active or
> not, what elevator they are using, whether one or more of the
> applications are issuing fsync() or sync() calls, and so on.

Good idea.  

The filesystems are all ext3 with default mount parameters.  The dmesgs
say that the filesystems are mounted in ordered data mode and that
barriers are not enabled.

mount says:

/dev/sda2 on / type ext3 (rw,errors=remount-ro,commit=0)
/dev/sda1 on /boot type ext3 (rw,commit=0)
/dev/sda3 on /home type ext3 (rw,commit=0)

> storage config

Do you mean the partition sizes?  Here's that:

$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              72G   52G   17G  77% /
tmpfs                 755M  4.0K  755M   1% /lib/init/rw
udev                  750M  212K  750M   1% /dev
tmpfs                 755M     0  755M   0% /dev/shm
/dev/sda1             274M  117M  143M  45% /boot
/dev/sda3              74G   37G   33G  53% /home

> elevator

CFQ

> sync-related calls

I don't have a test from the time I ran rsync (but I'll check that
tonight), but I traced the currently running emacs and iceweasel
(a.k.a. firefox) with "strace -p PID 2>&1 | grep sync".  That didn't
turn up any sync-related calls.

(I checked the firefox because I seem to remember that it used to do
fsync absurdly often, but I also seem to remember that the outcry made
them stop.)

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
