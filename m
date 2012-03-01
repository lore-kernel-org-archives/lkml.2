Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2CACxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:53:32 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50388 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2CACxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:53:31 -0500
Date: Thu, 1 Mar 2012 11:53:29 +0900
From: Simon Horman <horms@verge.net.au>
To: Eugene Surovegin <surovegin@google.com>
Cc: linux-kernel@vger.kernel.org, kexec-list <kexec@lists.infradead.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
Message-ID: <20120301025328.GF10053@verge.net.au>
References: <1330536083-13098-1-git-send-email-surovegin@google.com>
 <20120301011811.GC16483@verge.net.au>
 <CANrfoUXd4L2bjBO+L8ZBCkc1dfnZahn39sB25zsrUMqGA5zY5A@mail.gmail.com>
 <20120301013200.GF16483@verge.net.au>
 <CANrfoUVTSh6jWckz2jt9+X6E6FSPL5OwqWNrcXchbo1BwkCLgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANrfoUVTSh6jWckz2jt9+X6E6FSPL5OwqWNrcXchbo1BwkCLgw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:39:55PM -0800, Eugene Surovegin wrote:
> On Wed, Feb 29, 2012 at 5:32 PM, Simon Horman <horms@verge.net.au> wrote:
> > On Wed, Feb 29, 2012 at 05:23:10PM -0800, Eugene Surovegin wrote:
> >> On Wed, Feb 29, 2012 at 5:18 PM, Simon Horman <horms@verge.net.au> wrote:
> >>
> >> > On Wed, Feb 29, 2012 at 09:21:23AM -0800, Eugene Surovegin wrote:
> >> > > Per-CPU allocations are not guaranteed to be physically contiguous.
> >> > > However, kdump kernel and user-space code assumes that per-CPU
> >> > > memory, used for saving CPU registers on crash, is.
> >> > > This can cause corrupted /proc/vmcore in some cases - the main
> >> > > symptom being huge ELF note section.
> >> > >
> >> > > Force page alignment for note_buf_t to ensure that this assumption holds.
> >> >
> >> > Ouch. I'm surprised there is an allocation on crash, perhaps
> >> > it could at least be done earlier? And am I right in thinking
> >> > that this change increases the likely hood that the allocation
> >> > could fail?
> >> >
> >>
> >> I'm not following. This allocation is done on start-up, not on crash.
> >> If you cannot allocate this much memory on system boot, I'm not sure what
> >> else you can do on this system....
> >
> > Sorry, my eyes deceived me. You are correct and I agree.
> >
> > Is it the case that note_buf_t is never larger than PAGE_SIZE?
> > If so I your patch looks good to me.
> 
> Currently, maximum note size is hardcoded in kexec-tools to 1024
> (MAX_NOTE_BYTES).
> Usually it's way less. IIRC on x86_64 it's 336 bytes.

Ok, understood.

Reviewed-by: Simon Horman <horms@verge.net.au>
