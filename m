Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423202Ab2LGTDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:03:12 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:60449 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab2LGTDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:03:09 -0500
X-ASG-Debug-ID: 1354906987-03d6a559e0872010001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 7 Dec 2012 14:03:06 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207190306.GB14972@shiny>
X-ASG-Orig-Subj: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126025520.GC22858@thunk.org>
 <20121126091202.GO32450@dastard>
 <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354906987
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.30
X-Barracuda-Spam-Status: No, SCORE=-1.30 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332, COMMA_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116366
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 COMMA_SUBJECT          Subject is like 'Re: FDSDS, this is a subject'
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:18:00AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 7 Dec 2012, Ric Wheeler wrote:
> > 
> > Review is part of the way we work as a community and we should figure out how
> > to fix our review process so that we can have meaningful results from the
> > review or we lose confidence in the process and it makes it much harder to get
> > reviewers to spend time reviewing when their reviews are ultimately ignored.
> 
> Christ, I promised myself to not respond any more to this thread, but the 
> insanity just continues, from people who damn well should know better.
> 
> The code wasn't merged. The review worked.
> 
> What you (and Dave, and Christoph) are trying to do is shut down a feature 
> that somebody else decided they needed. That's not what code review is all 
> about, and dammit, don't try to even claim it is.
> 
> So stop these dishonest and disingenious arguments. They are full of crap.
> 
> No amount of "review" has any meaning what-so-ever on whether somebody 
> else decides they need a feature or not. You can review all you want, but 
> it's irrelevant - if some company decides they are going to ship or use a 
> feature, it's out of your hands.
> 
> What got merged was a ONE-LINER to make sure that possible future 
> development didn't unnecessarily make things any more confusing, with the 
> knowledge that there was a user of the code you didn't like. 
> 
> Every single argument I've heard of from the "please revert" camp has been 
> inane. And they've been *transparently* inane, to the point where I don't 
> understand how you can make them with a straght face and not be ashamed.

I really agree with Dave's statement that we should ioctl for private
features and system call for features other filesystems are likely to
implement.  So we really shouldn't have private bits in fallocate in use
in production systems.

That's not what happened though, and the right way forward from here is
to give the bit to the feature, maybe with a generic name like
FALLOCATE_WITHOUT_BEING_HORRIBLY_SLOW.  It should have been done
differently, but it wasn't.  And it's a problem we all have, so it makes
sense that we'll all want to address it somehow.

On a single flash drive doing random 4K writes, xfs does 950MB/s into
regular extents but only 400MB/s into preallocated extents.

http://masoncoding.com/presentation/perf-linuxcon12/fallocate.png

ext4 has a bigger hit, but there's a little room for improvement all
around.

Maybe we should use this thread as the starting point for the proper
12-18 months of bike shedding for a real fix?

-chris

