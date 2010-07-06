Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0GFAyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:54:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0GFAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:54:21 -0400
Date: Mon, 5 Jul 2010 21:54:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
Message-ID: <20100706005409.GC23506@ghostprotocols.net>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6> <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com> <20100705174450.GB23506@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705174450.GB23506@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 05, 2010 at 02:44:50PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Jul 05, 2010 at 10:30:47AM -0400, Chase Douglas escreveu:
> > On May 19, 2010, at 3:57 PM, Masami Hiramatsu wrote:
> > > Here is a series of patches which improves perf probe to
> > > add below features. I cleared some coding style issues.

> > > - String support, which enables dynamic events to trace string
> > >  variables instead of its address.

> > > - Fixed-index array entry support, which allows user to trace
> > >  an array entry with digit index, e.g. array[0].

> > > - Global/static variable support, which allows user to trace
> > >  global or static variables, as same as local one.

> > What's the status of these patches? They seem very useful to me, but I
> > don't see them in Arnaldo's tree at git.kernel.org.

> Thanks for reminding me about these ones, will look at them to get them
> in perf/core.

Masami, I fixed up a minor conflict and while trying it this happened:

[root@emilia ~]# perf probe -a 'bio_split bi->bi_io_vec[0]'
kprobe_events file does not exist - please rebuild kernel with CONFIG_KPROBE_EVENT.
  Error: Failed to add events. (-1)

But on a second try:

[root@emilia ~]# l /sys/kernel/debug/tracing/kprobe_events 
-rw-r--r-- 1 root root 0 Jul  5 18:37 /sys/kernel/debug/tracing/kprobe_events
[root@emilia ~]# cat /sys/kernel/debug/tracing/kprobe_events 
[root@emilia ~]#
[root@emilia ~]# perf probe -a 'bio_split bi->bi_io_vec[0]'
Add new event:
  probe:bio_split      (on bio_split with bi_io_vec=bi->bi_io_vec[0])

You can now use it on all perf tools, such as:

	perf record -e probe:bio_split -aR sleep 1

[root@emilia ~]# cat /sys/kernel/debug/tracing/kprobe_events 
p:probe/bio_split bio_split bi_io_vec=+0(+72(%di)):u64
[root@emilia ~]# 

I'll push it as is, posting the pull request with the patches today,
please check if everything is ok and send fixups if needed,

Thanks,

- Arnaldo
