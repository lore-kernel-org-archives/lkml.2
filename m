Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1JQRsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:48:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8887 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1JQRse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:48:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=SJ9l0Zbp5xiw0rgAD+75tPiZ+T69r1Thw60SYDm0aL7lKKzNb8eI0WgimAcKiyNM1
	Fxo+kVyq1kB4j0fHa2t2A==
Date: Mon, 17 Oct 2011 10:48:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Rob Clark <rob.clark@linaro.org>
cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
In-Reply-To: <CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1110171031290.2545@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain> <20110705144140.23872.86541.stgit@localhost.localdomain> <alpine.LSU.2.00.1107071742250.10362@sister.anvils> <20110708093859.299958df@lxorguk.ukuu.org.uk> <alpine.LSU.2.00.1107080917430.1781@sister.anvils>
 <20110711172517.46907e62@lxorguk.ukuu.org.uk> <alpine.LSU.2.00.1107111033440.1752@sister.anvils> <CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com> <alpine.LSU.2.00.1110101102330.21957@sister.anvils>
 <CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Rob Clark wrote:
> On Mon, Oct 10, 2011 at 1:37 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I haven't rushed to address the 4GB issue, but what I have in mind is
> > killing two-and-a-half birds with one stone, by putting a little cookie
> > into the swapper_space radix_tree when we free a swapcache page, that
> > specifies node/zone and hashes object/offset.
> 
> Without really knowing the details about how hard it would be to
> implement, it would solve one additional problem if we could have a
> per-mapping callback fxn for allocating pages.
> 
> At least on ARM (but I guess probably some other architectures too),
> we really want to avoid having a page mapped cachable in the kernel,
> and uncached/writecombine in userspace.  With a per-mapping page
> allocation fxn, we could do something like
> dma_alloc_coherant/writecombine (for example) to allocate backing
> pages for GEM buffers which are mmap'd to userspace as something other
> than cachable.

It feels to me like GEM is pulling shmem in an ever more alien direction:
these device constraints are so foreign to the nature of tmpfs; and
beyond my expertise, so that I'd be ever more likely to make the wrong
decisions (mixing swap and uncached pages? hmmm).

We ought to re-examine whether GEM should be using tmpfs at all, whether
it would be better served by its own filesystem or other infrastructure.

Really, the one reason for wanting tmpfs is to have the benefit of offload
to swap (and that is indeed a feature I wouldn't care to distribute around
to drivers).

Hugh
