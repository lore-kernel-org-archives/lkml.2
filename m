Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0GLQ1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:27:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:50749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0GLQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:27:51 -0400
Date: Mon, 12 Jul 2010 13:26:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
Message-ID: <20100712162659.GG25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
 <20100712140023.GC25238@ghostprotocols.net>
 <20100712153357.GB23776@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712153357.GB23776@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 12, 2010 at 09:03:57PM +0530, Srikar Dronamraju escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> [2010-07-12 11:00:23]:
> > Em Mon, Jul 12, 2010 at 04:04:12PM +0530, Srikar Dronamraju escreveu:
> > > perf probe for uprobes would use make_absolute_path.
> > > make_absolute_path can be used to convert a file name to a dso name.

> > > so if user specifies the function to be traced as malloc@/lib/libc.so.6
> > > it needs to be converted to malloc@libc-2.5.so

> > Isn't this the other way around? I.e. "if the user specifies
> > malloc@libc-2.5.so it needs to be converted to malloc@/lib/libc.so.6"?

> Actually we dont need to convert malloc@libc-2.5.so to a
> malloc@/lib/libc.so.6. Because we can match the shortname of the dso. 

Humm, I see, it is path based, so the first libc-2.5.so that appears in
the LD_LIBRARY_PATH equivalent used in this code will be user, is that
right?

I.e. if I'm testing some new libc-2.5.so that provides, say, private
futexes while the one in my distro still doesn't have this feature, I'll
have to specify the absolute name or make sure it is before the system's
libc-2.5.so in the LD_LIBRARY_PATH, right?
 
> Problem will occur when users specifies a full path of the file.
> Since the file can refer to a symbolic link and the dso will have just
> the short name or the target file name. Here I am using
> make_absolute_path to resolve to the target file.
> Now we can then either check on dso full names or short names.
> I have chosen to use the short name.

Humm, so what you want is one of:

realpath - return the canonicalized absolute pathname
canonicalize_file_name -  return the canonicalized filename

Can you please check the man pages for both before we decide
re-introducing make_absolute_path?
 
> > Also please remove the xstrdup and die calls from this function, we're
> > trying to get rid of all such 'panic' like functions so that we can
> > librarize as much code as possible.
> 
> Okay, Can I do that in subsequent versions of the patchset?

yeah, its ok if you don't end up using one of the suggested libc
functions above :-)

- Arnaldo
