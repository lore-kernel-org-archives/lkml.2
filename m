Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab0EZImd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:42:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45112 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0EZImb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wIDk+lN5gOlNJQcBBI7BYmOu3yRPUssv5qvA8PlN1JxOyUL39eV/xLaEEIcte93MfK
         PFpfNUdqPZmtx9BKiltcJFzE+Qz35yYXnNgeYrG5lMtkzr51HpY3iJCyJpqb4YjXYOeq
         Z95w0pGNrffYV7ehrTXV4Xzqm/t0OPM76Mt6E=
Date: Wed, 26 May 2010 11:42:02 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
Message-ID: <20100526084201.GA22438@localhost>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
 <20100525201259.GA5370@nowhere>
 <AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com>
 <4BFCCBB0.6040101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCCBB0.6040101@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:20:16PM +0800, Li Zefan wrote:
> Pekka Enberg wrote:
> > On Tue, May 25, 2010 at 11:13 PM, Frederic Weisbecker
> > <fweisbec@gmail.com> wrote:
> >>> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
> >> Deprecated. We have the kmem trace event that are a full replacement now.
> >> Pekka, Gabriel, can we remove it now?
> > 
> > I don't think ftrace supports boot-time tracing which kmemtrace did.
> 
> We can do boot-time tracing by passing "trace_event=" kernel parameter.
> 
> By passing "ftrace=kmemtrace", kmemtrace can be started when
> calling tracer_alloc_buffer(), which is an early_initcall.
> While trace events are inititialized as a fs_initcall,  it can
> be modified to an early_initcall.
> 
> Furthermore, I noticed the discussion on perf persistent events, which
> seems to enable perf trace at boot time, so I think perf-kmem can take
> advantage of this and will be a full-replacement of kmemtrace soon ?
> 
> > That said, I was probably the only one actually using the feature so
> > maybe we can just nuke kmemtrace at this point...
> 
> If you agree on removing kmemtrace now, I'll re-send the patch.

I don't understand... wasn't the old kmemtrace (the relayfs based stuff)
removed a long time ago? Right now it's just the hooks and code that
sets up tracing and printers.

Or does it happen that that code isn't necessary for 'perf kmem' to do
its job?

And yeah, I'm all for the perf stuff, kmemtrace-user (the out-of-tree
userspace tools) has been obsolete since the shift to ftrace.

As for early tracing, that was possible with the relayfs variant, it
required only the SLAB layer to be up IIRC. But that stopped working
once it got converted to ftrace (kmemtrace_init() is a nop).


	Eduard

