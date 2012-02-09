Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2BIR7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:59:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50253 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2BIR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:59:53 -0500
Date: Thu, 9 Feb 2012 09:59:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120209175948.GE19392@google.com>
References: <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
 <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
 <CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
 <20120208162925.GA19392@google.com>
 <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 09, 2012 at 02:22:32PM +0800, Shaohua Li wrote:
> >> Tried all the options, the regression still exists. Any new idea?
> >> I'll spend some time on it if I can get anything
> >
> > Can you please try the following one?  Thanks a lot!
> doesn't work.
> I also double confirmed b2efa05265d62 causes the regression

I'll soon send a RCU based version.  I'm still having trouble
reproducing the regression tho.  I've tried a few different things.

* Heavy thrashing: Disk IO dominates everything and CPUs aren't too
  busy.  While how swap behaves affects completion time, I don't see
  how CPU locking issue comes into play at all under this
  circumstance.

* Some swap load: Simulated w/ 1G memory limit and buliding defconfig
  kernel in tmpfs.  Swap grows to a couple hundred megabytes but build
  time is still dominated by CPU.  I didn't see any meanginful
  difference before and after the commit - both in terms of wallclock
  and CPU times.

Maybe these two were too extreme to show the problem and I need to
push memory limit a bit further, but it would be great if you can give
me a bit more details about your testing.

* How much memory does the machine have?  How is the tmpfs setup and
  filled up?  What's the size of the tmpfs and the output of "free -m"
  right before test starts?  While the test is running, how occupied
  are the CPUs?  On test completion, what's the output of "free -m"?

* What exactly is the test and what do you measure?  What does "12%
  regression" mean?  Is it wallclock time or CPU time?  If it's CPU
  time, does systime increase dominate the regression?

Thanks.

-- 
tejun
