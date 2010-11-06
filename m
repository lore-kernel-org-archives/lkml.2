Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0KFTLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:11:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0KFTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:11:14 -0400
Date: Sat, 6 Nov 2010 12:10:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sanjoy Mahajan <sanjoy@olin.edu>
Cc: Dave Chinner <david@fromorbit.com>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Ted Ts'o" <tytso@mit.edu>, Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101106121042.10b3d96b@infradead.org>
In-Reply-To: <E1PELiI-0001Pj-8g@approx.mit.edu>
References: <20101105014334.GF13830@dastard>
	<E1PELiI-0001Pj-8g@approx.mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010 08:48:13 -0400
Sanjoy Mahajan <sanjoy@olin.edu> wrote:

> Dave Chinner <david@fromorbit.com> wrote:
> 
> > I think anyone reporting a interactivity problem also needs to
> > indicate what their filesystem is, what mount paramters they are
> > using, what their storage config is, whether barriers are active or
> > not, what elevator they are using, whether one or more of the
> > applications are issuing fsync() or sync() calls, and so on.
> 
> Good idea.  
> 
> The filesystems are all ext3 with default mount parameters.  The
> dmesgs say that the filesystems are mounted in ordered data mode and
> that barriers are not enabled.

btw few more things to try (from my standard rc.local script):

echo 4096 > /sys/block/sda/queue/nr_requests

for i in `pidof kjournald` ; do ionice -c1 -p $i ; done

echo 75 >  /proc/sys/vm/dirty_ratio


(replace sda with whatever your disk is of course)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
