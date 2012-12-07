Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2LGVna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:43:30 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:51439 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab2LGVn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:43:28 -0500
X-ASG-Debug-ID: 1354916607-03d6a508b81ae310001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 7 Dec 2012 16:43:25 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207214325.GB25713@shiny>
X-ASG-Orig-Subj: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Theodore Ts'o <tytso@mit.edu>, Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <201212051148.28039.Martin@lichtvoll.de>
 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
 <20121206120532.GA14100@infradead.org>
 <20121207011628.GB16373@gmail.com>
 <50C22923.90102@redhat.com>
 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
 <20121207190306.GB14972@shiny>
 <20121207204325.GC29435@thunk.org>
 <20121207210932.GA25713@shiny>
 <20121207212743.GE29435@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121207212743.GE29435@thunk.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354916607
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0065 1.0000 -1.9788
X-Barracuda-Spam-Score: -1.38
X-Barracuda-Spam-Status: No, SCORE=-1.38 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=COMMA_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116375
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 COMMA_SUBJECT          Subject is like 'Re: FDSDS, this is a subject'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:27:43PM -0700, Theodore Ts'o wrote:
> On Fri, Dec 07, 2012 at 04:09:32PM -0500, Chris Mason wrote:
> > Persistent trim is what I had in mind, but there are other ideas that do
> > imply a change in behavior as well.  Can we safely assume this feature
> > won't matter on spinning media?  New features like persistent
> > trim do make it much easier to solve securely, and using a bit for it
> > means we can toss back an error to the app if the underlying storage
> > isn't safe.
> 
> We originally implemented no hide stale for spinning media.  Some
> folks have claimed that for XFS their superior technology means that
> no hide stale doesn't buy them anything for HDD's.  I'm not entirely
> sure I buy this, since if you need to update metadata, it means at
> least one extra seek for each random write into 4k preallocated space,
> and 7200 RPM disks only have about 200 seeks per second.

True, 7200 RPM disks are slow, but even allowing them to expose stale
data just makes them a little less slow.

I know it's against the rules to pretend that disks don't matter.  But
really, once you're doing random IO into a spindle you've given up on
performance anyway.

-chris
