Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2LJSHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2LJSHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:07:08 -0500
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to
 fallocate UAPI
From: Steven Whitehouse <swhiteho@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20121210173739.GA1359@thunk.org>
References: <20121126025520.GC22858@thunk.org>
	 <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de>
	 <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com>
	 <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com>
	 <50C22923.90102@redhat.com>
	 <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org>
	 <20121207190306.GB14972@shiny> <20121208001705.GO27172@dastard>
	 <20121210173739.GA1359@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 10 Dec 2012 18:05:59 +0000
Message-ID: <1355162759.2704.50.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-12-10 at 12:37 -0500, Theodore Ts'o wrote:
> On Sat, Dec 08, 2012 at 11:17:05AM +1100, Dave Chinner wrote:
> > I wouldn't recommend XFS_IOC_ALLOCSP as a user-friendly interface.
> > The concept, however, implemented by a new fallocate()
> > flag (say FALLOC_FL_WRITE_ZEROS) so that the filesystem knows that
> > the application considers unwritten extents undesirable is exactly
> > the sort of thing that we should be considering implementing.
> 
> What's the point of using a new flag like this (or XFS's
> XFS_IOC_ALLOCSP) for writing zeros during preallocation as oppoised to
> simply doing a fallocate() followed by zeroing the data via a O_DIRECT
> write system call?
> 

If the block device can zero out blocks more efficiently than just
writing zeros (i.e. via sb_issue_zeroout()) then this could be faster.
In fact GFS2 already zeros out fallocate()d extents in this way because
it has no way to mark unwritten extents in its metadata, and we did not
want to leave them uninitialised,

Steve.


