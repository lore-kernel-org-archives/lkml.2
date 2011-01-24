Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1AXV6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:58:05 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44709 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1AXV6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=iciXQ63un+AtgwI8uweFpnZBN7hy2YeMOfNujZj3iOCKLt9Xpc9aDoh2JzqcYY6E9G
         ZHYZWHufrloy3FOhlbyVST16eWOwrRap/g2P+0vwd05MMNVKdRIuqGAE/+1q/fQ6lRba
         b3Z5fOJz+9cQq4cRxhAw5CCneXOR4U/lUWUMo=
Date: Mon, 24 Jan 2011 19:57:55 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        tardyp@gmail.com, jean.pihet@newoldbits.com,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Perf ABI versioning
Message-ID: <20110124215755.GE6367@ghostprotocols.net>
References: <201101241704.01021.trenn@suse.de>
 <20110124203449.GC2318@nowhere>
 <20110124212838.GB13724@elte.hu>
 <201101242249.14471.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101242249.14471.trenn@suse.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 10:49:13PM +0100, Thomas Renninger escreveu:
> On Monday 24 January 2011 22:28:38 Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > This may be generally useful to help dealing with tracepoint ABI changes.
> > > 
> > > But instead of a global tracing ABI number, I would rather suggest one number per 
> > > tracepoint subsystem (sched, power, etc...).
> > 
> > Nooooooooooo ... !!! :-)
> > 
> > Please lets stop this madness before it gets too serious: we dont do ABI version 
> > numbering in Linux, full stop.
> Ok... :)
>  
> > We use 'natural' ABIs where the lack of an ABI component triggers some sort of 
> > clean, finegrained error. Like a -EINVAL on a not-yet-implemented ABI component, a 
> > non-existent file entry, or -ENOSYS on a non-existent syscall.
> If the whole stuff matures, someone might think about a nice concept to be able
> to shift around perf.data binaries which can be processed by userspace tools,
> independent of the kernel version running below on which the perf.data
> was produced.

We try to do that already, things like sample_id_all that is a feature
present on a new kernel are capability queried by trying to ask the
kernel for it and if it fails, cope with that and do as before it, in
some cases warning the user if the fallback can lead to inacuracies.

Shifting around perf.data files accross arquitectures and OS/vendor
releases is an everyday goal.

I.e. the new perf binary works with older kernels.

We also try hard to keep the latest tools building on older kernels.

Using the /format file hashed as peterz said is elegant, fine grained
content based ABI number :-)

- Arnaldo
