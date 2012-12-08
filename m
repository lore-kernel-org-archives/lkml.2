Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2LHBjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:39:54 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:49732 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757547Ab2LHBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:39:52 -0500
X-ASG-Debug-ID: 1354930791-03d6a50cb5d40520001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 7 Dec 2012 20:39:49 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Dave Chinner <david@fromorbit.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121208013949.GD25713@shiny>
X-ASG-Orig-Subj: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121208001705.GO27172@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121208001705.GO27172@dastard>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354930791
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0158 1.0000 -1.9184
X-Barracuda-Spam-Score: -1.19
X-Barracuda-Spam-Status: No, SCORE=-1.19 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332, COMMA_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116392
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 COMMA_SUBJECT          Subject is like 'Re: FDSDS, this is a subject'
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:17:05PM -0700, Dave Chinner wrote:
> On Fri, Dec 07, 2012 at 02:03:06PM -0500, Chris Mason wrote:

[ dead and beaten fallocate ponies ]

> 
> > On a single flash drive doing random 4K writes, xfs does 950MB/s into
> > regular extents but only 400MB/s into preallocated extents.
> > 
> > http://masoncoding.com/presentation/perf-linuxcon12/fallocate.png
> 
> This is bordering on irrelevancy, but can you provide the workload
> you were running to generate this graph?  Random 4k writes could be
> anything, really.

This one was fio aio/dio, I'll dig out the job file and rerun it on
3.7-rc on Monday.  Any real random write is going to show this with
enough load.

> 
> In my experience, applications that actually do processing between
> random write IOs don't see anywhere near the same degradation as
> such micro-benchmarks tend to indicate can occur with unwritten
> extents. Are you seeing this level of degradation in real-world applications?
> If you give me a reason to fix it (and the hardware to test it on),
> I'm pretty sure I can bring the overhead down to just a few percent
> on fully featured SSDs like FusionIO devices...

We should have a card I can send, drop me the address.

For the workload...that's harder.  We can talk all day about what a
normal random write workload is, but if you have a fio job that you
think represents real world, I can run that.

[ much nodding ;) ]
