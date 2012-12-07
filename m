Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424653Ab2LGV5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:57:43 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37410 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424620Ab2LGV5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:57:40 -0500
Date: Fri, 7 Dec 2012 16:57:27 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121207215727.GF29435@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Chris Mason <clmason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
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
 <50C262AE.5060701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C262AE.5060701@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 04:42:06PM -0500, Ric Wheeler wrote:
> The other things that I think we should try would be to convert over
> larger chunks as we discussed on the list back in the summer (just
> because the user writes 4KB does not mean that we cannot flip over
> 1MB and zero that).

Writing a megabyte is not free.  If you assume that your HDD has a
sustained write throughput of 100-125 MB/s, writing a megabyte will
take 8-10ms.  It might be a win if you amortize it over a large number
of writes, but it doesn't help your 99.9 percentile latency numbers.
(99.9 percentile latency numbers matters because eventually you'll
have a user request which hits multiple serial long latency
operations, and then the delay looks **really** user visible.)

	    	     	       	     		- Ted
