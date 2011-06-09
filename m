Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab1FIMf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:35:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39073 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab1FIMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fwUCjS7eaNiNKmt+dGZUw+C+2FUK/3jZibVoO2g84x4E66W5JF+d+cIF4SFvktG/E3
         NpBaCsXl7Am1px91SLIy8Ih1fe7/Pc0gABmL/yG9eaR76LPf7z3FEDslhEMVHLTyXBHb
         0WdemyV467KjEIdFpUgKDydRaU8z/ywOPVYos=
Date: Thu, 9 Jun 2011 14:35:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf update
Message-ID: <20110609123519.GF25771@somewhere.redhat.com>
References: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
 <1307610813.3941.23.camel@twins>
 <20110609091924.GA8188@elte.hu>
 <20110609114313.GA15332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609114313.GA15332@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 01:43:13PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Tue, 2011-06-07 at 16:56 +0200, Frederic Weisbecker wrote:
> > > 
> > > > Frederic Weisbecker (1):
> > > >       perf: Split up buffer handling from core code
> > > > 
> > > > 
> > > >  kernel/events/Makefile   |    2 +-
> > > >  kernel/events/buffer.c   |  400 ++++++++++++++++++++++++++++++++++++++++
> > > >  kernel/events/core.c     |  458 ++--------------------------------------------
> > > >  kernel/events/internal.h |   70 +++++++
> > > >  4 files changed, 487 insertions(+), 443 deletions(-)
> > > 
> > > Looks about right.
> > > 
> > > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > thanks, i'll pull it it and test it.
> 
> Note, i ended up applying it by hand:
> 
>  - fixed a build error,
> 
>  - streamlined the renaming: we really want this to be ring_buffer.c 
>    (most of the complexity comes from this not being a simple buffer 
>    but a ring-buffer)
> 
>  - i streamlined the naming around it: struct ring_buffer 
>    internalized via internal.h (it does not clash with ftrace's 
>    ring-buffer)
> 
> It all looks and reads much nicer now, but please double check the 
> commit as well :-)
> 
> One other rename i'd like to do is:
> 
>    struct perf_output_handle		=> struct rb_handle
> 
>    perf_output_begin()			=> rb_open()
>    perf_output_copy()			=> rb_write()
>    perf_output_sample()			=> rb_write_sample()
>    perf_output_end()			=> rb_close()
> 
> Which really makes it a lot more apparent that it's a regular 
> input/output flow defined over the ring-buffer!
> 
> I can do this if this is fine with everyone. There will be no change 
> in functionality.

I feel more comfortable if we keep the perf_outpout_*() naming, having some
global rb_* would pollute the global namespace.

perf_rb_* namespace would be fine as well.

Thanks.

> 
> Thanks,
> 
> 	Ingo
