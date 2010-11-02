Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0KBLw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 07:52:59 -0400
Received: from webmail.olin.edu ([209.94.128.49]:43047 "EHLO EXCAS01.olin.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0KBLwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 07:52:53 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 07:52:53 EDT
Message-ID: <E1PDFKe-0005sq-2D@approx.mit.edu>
To: Chris Mason <chris.mason@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, <Peter.Zijl@MIT.EDU>
Subject: Re: 2.6.36 io bring the system to its knees
In-Reply-To: Your message of "Thu, 28 Oct 2010 13:01:32 EDT."
             <20101028170132.GY27796@think>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Tue, 2 Nov 2010 07:47:15 -0400
From: Sanjoy Mahajan <sanjoy@olin.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> wrote:

> > This has the appearance of some really bad IO or VM latency
> > problem. Unfixed and present in stable kernel versions going from
> > years ago all the way to v2.6.36.
> 
> Hmmm, the workload you're describing here has two special parts.
> First it dramatically overloads the disk, and then it has guis doing
> things waiting for the disk.

I think I see this same issue every few days when I back up my hard
drive to a USB hard drive using rsync.  While the backup is running, the
interactive response is bad.  A reproducible measurement of the badness
is starting an rxvt with F8 (bound to "rxvt &" in my .twmrc).  Often it
takes 8 seconds for the window to appear (as it just did about 2 minutes
ago)!  (Starting a subsequent rxvt is quick.)

The command for running the backup:

  rsync -av --delete /etc /home /media/usbdrive/bak > /tmp/homebackup.log

The hardware is a T60 w/ Intel graphics and wireless, 1.5GB RAM, 5400rpm
160GB harddrive w/ ext3 filesystems, and it's running vanilla 2.6.36.
There's not much memory pressure.  The swap is mostly empty, and there's
usually a Firefox eating 500MB of RAM.  Even Emacs at 50MB is in the
noise compared to the Firefox.

Here's the 'free' output:

             total       used       free     shared    buffers     cached
Mem:       1545292    1500288      45004          0      92848     713988
-/+ buffers/cache:     693452     851840
Swap:      2000088      22680    1977408

What tests or probes are worth running when the problem reappears in
order to find the root cause?

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
