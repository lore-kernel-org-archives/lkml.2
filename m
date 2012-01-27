Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2A0K7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:59:01 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34589
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab2A0K7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:59:00 -0500
Date: Fri, 27 Jan 2012 05:58:59 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: XFS problem
Message-ID: <20120127105859.GC23335@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
 <20120124213936.GA1505@infradead.org>
 <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 01:57:34PM -0200, Kelbel Junior wrote:
> Well, in 24/01 i upgrade to the kernel 3.2.1 in one server and forgot
> read my emails...until now it's running without problems.
> Then, yesterday i put kernel 3.2.1 on another server and this morning
> a several same messages "server013 kernel: XFS: possible memory
> allocation deadlock in kmem_alloc (mode:0x250)" and delays.
> 
> (without call trace because i forgot to apply that patch with dump_stack)

Not a problem, we know where it comes from now.

> I work in a cache solution company, so I/O performance is very
> important in our context.

What I'm really curious about is what kind of workloads you have.  We
should only run into problems here if we have a huge extent indirection
array, which points to a massively fragmented file.  Right now the
handling of that isn't optimal, and we need to improve on that.  But
you'd probably get better results by avoiding that massive fragmentaion
in the first place, e.g. try to preallocate or set extent size hints
if you do random writes to a sparse file.

