Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0EGEtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:49:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54365 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0EGEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n2l6cPyL2m6Ug5u1Fg4vrfQqJWvGRFnUwnR2buqyZcZyv6FWiM9ioSOU/a6bWUZdrU
         QUgN1Z9efZFnZVrRf44q5wFzHZt8w30g/8PW/meO7LZddLk8+mrvU/T5mjmQcHA7SzYS
         79ycSsmc//ZzdpBwVwyinMIcxhbb9+up1W4mE=
Date: Fri, 7 May 2010 06:49:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/9 - v2][RFC] tracing: Move fields from event to class
	structure
Message-ID: <20100507044914.GE8069@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034202.506915822@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504034202.506915822@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 11:40:49PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Move the defined fields from the event to the class structure.
> Since the fields of the event are defined by the class they belong
> to, it makes sense to have the class hold the information instead
> of the individual events. The events of the same class would just
> hold duplicate information.
> 
> After this change the size of the kernel dropped another 8K:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5774316	1306580	9351592	16432488	 fabd68	vmlinux.reg
> 5774503	1297492	9351592	16423587	 fa9aa3	vmlinux.fields
> 
> Although the text increased, this was mainly due to the C files
> having to adapt to the change. This is a constant increase, where
> new tracepoints will not increase the Text. But the big drop is
> in the data size (as well as needed allocations to hold the fields).
> This will give even more savings as more tracepoints are created.
> 
> Note, if just TRACE_EVENT()s are used and not DECLARE_EVENT_CLASS()
> with several DEFINE_EVENT()s, then the savings will be lost. But
> we are pushing developers to consolidate events with DEFINE_EVENT()
> so this should not be an issue.
> 
> The kprobes define a unique class to every new event, but are dynamic
> so it should not be a issue.
> 
> The syscalls however have a single class but the fields for the individual
> events are different. The syscalls use a metadata to define the
> fields. I moved the fields list from the event to the metadata and
> added a "get_fields()" function to the class. This function is used
> to find the fields. For normal events and kprobes, get_fields() just
> returns a pointer to the fields list_head in the class. For syscall
> events, it returns the fields list_head in the metadata for the event.
> 
> v2:  Fixed the syscall fields. The syscall metadata needs a list
>      of fields for both enter and exit.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Now I need to recover from my CPP headache before reviewing
this set further ;)

