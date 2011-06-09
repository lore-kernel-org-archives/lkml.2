Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1FIQkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:40:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33265 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1FIQkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=adRi30GUcb2kIrQNR8ZGv6ROSfwi0KmnXNezEM04GRdfHxBN6DkhkZ59fVMJHuKe/b
         jSMMpK3I7OCZtSSBid0+FOM/ISrwwyDNQH7S6bVAy31rpX6E1/oNS9MjFgHWuAjdvpVT
         vl4n2QuubwpMDll3BHXCZnbAB+42zH/tFCqMo=
Date: Thu, 9 Jun 2011 18:40:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf update
Message-ID: <20110609164021.GG25771@somewhere.redhat.com>
References: <1307458585-24078-1-git-send-email-fweisbec@gmail.com>
 <1307610813.3941.23.camel@twins>
 <20110609091924.GA8188@elte.hu>
 <20110609114313.GA15332@elte.hu>
 <20110609123519.GF25771@somewhere.redhat.com>
 <20110609131732.GA21100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609131732.GA21100@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 03:17:32PM +0200, Ingo Molnar wrote:
> > > 
> > >  - streamlined the renaming: we really want this to be ring_buffer.c 
> > >    (most of the complexity comes from this not being a simple buffer 
> > >    but a ring-buffer)
> > > 
> > >  - i streamlined the naming around it: struct ring_buffer 
> > >    internalized via internal.h (it does not clash with ftrace's 
> > >    ring-buffer)
> > > 
> > > It all looks and reads much nicer now, but please double check the 
> > > commit as well :-)
> > > 
> > > One other rename i'd like to do is:
> > > 
> > >    struct perf_output_handle		=> struct rb_handle
> > > 
> > >    perf_output_begin()			=> rb_open()
> > >    perf_output_copy()			=> rb_write()
> > >    perf_output_sample()			=> rb_write_sample()
> > >    perf_output_end()			=> rb_close()
> > > 
> > > Which really makes it a lot more apparent that it's a regular 
> > > input/output flow defined over the ring-buffer!
> > > 
> > > I can do this if this is fine with everyone. There will be no change 
> > > in functionality.
> > 
> > I feel more comfortable if we keep the perf_outpout_*() naming, having some
> > global rb_* would pollute the global namespace.
> 
> Hm, using the rb_ prefix is not good due to the (conceptual) clash 
> with rbtree.h primitives.
> 
> > perf_rb_* namespace would be fine as well.
> 
> How about:
> 
>     struct perf_output_handle		=> struct ring_buffer_handle
>  
>     perf_output_begin()			=> ring_buffer_open()
>     perf_output_copy()			=> ring_buffer_write()
>     perf_output_sample()		=> ring_buffer_write_sample()
>     perf_output_end()			=> ring_buffer_close()
> 
> ?
> 
> It doesn't clash with existing names.

For the same reasons I don't like the rename you did of the perf buffer into
struct ring_buffer, I think we shouldn't do this.

This is a generic naming that belongs to some very universal datatype. There
is no good reason to find that generic concept naming exported from a subsystem
that is not a generic implementation of that datatype.

And it's not because it doesn't yet clash with existing names that it's a good
choice.

Why not "struct perf_ring_buffer" ? And then perf_ring_buffer_begin()? or perf_rb_begin()
if it's too long.

> 
> Thanks,
> 
> 	Ingo
