Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0KDQF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:05:57 -0400
Received: from excas01.olin.edu ([209.94.128.49]:51290 "EHLO EXCAS01.olin.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0KDQFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:05:55 -0400
Message-ID: <E1PE2Jp-00031X-Tx@approx.mit.edu>
To: Chris Mason <chris.mason@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, <Peter.Zijl@MIT.EDU>
Subject: Re: 2.6.36 io bring the system to its knees
In-Reply-To: Your message of "Tue, 02 Nov 2010 09:12:39 EDT."
             <20101102131239.GA8680@think>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Thu, 4 Nov 2010 12:05:41 -0400
From: Sanjoy Mahajan <sanjoy@olin.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So this sounds like the backup is just thrashing your cache.

I think it's more than that.  Starting an rxvt shouldn't take 8 seconds,
even with a cold cache.  Actually, it does take a while, so you do have
a point.  I just did

  echo 3 > /proc/sys/vm/drop_caches

and then started rxvt.  That takes about 3 seconds (which seems long,
but I don't know wherein that slowness lies), of which maybe 0.25
seconds is loading and running 'date':

$ time rxvt -e date
real	0m2.782s
user	0m0.148s
sys	0m0.032s

The 8-second delay during the rsync must have at least two causes: (1)
the cache is wiped out, and (2) the rxvt binary cannot be paged in
quickly because the disk is doing lots of other I/O.  

Can the system someknow that paging in the rxvt binary and shared
libraries is interactive I/O, because it was started by an interactive
process, and therefore should take priority over the rsync?

> Does rsync have the option to do an fadvise DONTNEED?

I couldn't find one.  It would be good to have a solution that is
independent of the backup app.  (The 'locate' cron job does a similar
thrashing of the interactive response.)

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
