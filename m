Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0ELOsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:48:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44749 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0ELOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dumSklzTyc9kuaCsWv99R5B0CEwWaw/P9YfbGsSzz+rFuGB1yfzAUM7+jVUOqhAn7a
         XcQgQPJDgDckIXBhCXvfdZ2gKj9gyfYZ+l3CYZgWn01EJMp+/jXKzq7y7CaZSua9UBZ9
         PiVYIba06aSYGWTN7TYZ8ZGuUyZd+O1agv1T4=
Date: Wed, 12 May 2010 16:48:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pierre Tardy <tardyp@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Subject: Re: [RFC] PyTimechart
Message-ID: <20100512144811.GA5405@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com> <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:
> > Plugging to the scripting API is really easy, run:
> >
> >        $ perf timechart record
> >        $ sudo ./perf trace -g python
> >        generated Python script: perf-trace.py
> 
> This is something that I want to try since I saw the perf scripting
> patch, thanks for the recipe, I'll look at it in the next few days.
> 
> The next problem is that perf timechart record is frozen on the number
> of event it records.



What do you mean? That it can't do incremental records or so?
It's supported by perf record, may be not by perf timechart but
that would be a matter of a little patch.


> Pytimechart is able to display irq:* and workqueues:* events, as well
> as trace_printks ( I dont know if perf is able to dump those )
> 
> I use trace_printk to mark the big traces with events I'm trying to debug.
> Being able to look at ISR and workqueues is very useful, and there is
> a special feature that warns when an ISR lasts more than 1ms.


No problem with the irq and workqueues, if that's really useful, we
can change perf timechart to handle this.

But we don't yet support trace_printk in perf. May be we could wrap
them in trace events.

Why not starting with a release that does the same things
than timechart and trying to integrate the rest incrementally?


> For inclusion in mainline, this might take more time. The quality of
> some portion of the code is far from being linux kernel's standards
> :-}


The code I'm looking at here doesn't look dirty to me at a glance:
http://gitorious.org/pytimechart/pytimechart/trees/master

