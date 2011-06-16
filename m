Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1FPJs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:48:27 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52684
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991Ab1FPJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:48:23 -0400
Date: Thu, 16 Jun 2011 05:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616094810.GA19965@infradead.org>
References: <BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
 <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
 <4DF92C80.3030106@codemonkey.ws>
 <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
 <4DF93010.1040006@codemonkey.ws>
 <4DF935C1.4020000@codemonkey.ws>
 <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
 <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
 <20110616092429.GA5484@infradead.org>
 <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 12:34:04PM +0300, Pekka Enberg wrote:
> Hi Christoph,
> 
> On Thu, Jun 16, 2011 at 09:21:03AM +0300, Pekka Enberg wrote:
> >> And btw, we use sync_file_range()
> 
> On Thu, Jun 16, 2011 at 12:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > Which doesn't help you at all. ?sync_file_range is just a hint for VM
> > writeback, but never commits filesystem metadata nor the physical
> > disk's write cache. ?In short it's a completely dangerous interface, and
> > that is pretty well documented in the man page.
> 
> Doh - I didn't read it carefully enough and got hung up with:
> 
>     Therefore, unless the application is strictly performing overwrites of
>     already-instantiated disk blocks, there are no guarantees that the data will
>     be available after a crash.
> 
> without noticing that it obviously doesn't work with filesystems like
> btrfs that do copy-on-write.

You also missed:

" This system call does not flush disk write caches and thus does not
  provide any data integrity on systems with volatile disk write
  caches."

so it's not safe if you either have a cache, or are using btrfs, or
are using a sparse image, or are using an image preallocated using
fallocate/posix_fallocate.

> What's the right thing to do here? Is fdatasync() sufficient?

Yes.

