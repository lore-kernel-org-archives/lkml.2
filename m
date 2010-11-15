Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab0KOOyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:54:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab0KOOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:54:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=osi57G+AgmSReM9iQtLkoyURWcNbbHyBKXXLnKw6mjjQC/YpYK5GggAgK9jJ68V88M
         oZk/CCeE2kvblLUB8A5/0CcbhASUMAuBIGvNWp8HCg/ukwkn4uPkEsiIQFaI9DTjA1yg
         cDUCc7lRzQNhOuaeTFIjk7mqMtnfl34SPQ+is=
Date: Mon, 15 Nov 2010 15:54:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
        lwoodman@redhat.com, hch@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
	x86 & x86_64
Message-ID: <20101115145359.GC5410@nowhere>
References: <20101110164413.GA5360@nowhere> <1289466549-7602-3-git-send-email-jolsa@redhat.com> <20101115134325.GA5410@nowhere> <20101115140632.GI7269@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115140632.GI7269@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 03:06:33PM +0100, Andi Kleen wrote:
> > Actually I don't see any reason right now to trace only kernel faults. Do you?
> > If that's needed, one can still check on post-processing that the address
> > was in the kernel.
> 
> I think the idea is to get more context on oopses. If the event only covers
> that the overhead in the common case (minus *_user) is much less,
> versus the more generalized points you use.



I see. OTOH, page faults should be pretty low freq events most of time,
probably not something that would add much tracing overhead.

The pity is that we have something like exclude_user/exclude_kernel
properties for events when used by perf, but we consider trace event
as always firing in the kernel, this one is an exception but it would
too tricky and too much an overkill to handle these attributes just
for this trace events.



> For tracing the whole page fault me think it's better to have 
> a generalized exception tracer with a filter on page fault.


You're right. A tracepoint in handle_mm_fault() would be perhaps
better. It should catch most tracepoints the users are interested
in. On the other hand we may miss part of the page fault
latency, like the mmap_sem contention. This can be measured using
lock events though.

But I'm probably missing other important things.

