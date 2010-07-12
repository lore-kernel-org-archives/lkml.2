Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0GLRfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:35:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58032 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0GLRfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:35:48 -0400
Date: Mon, 12 Jul 2010 22:56:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
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
Message-ID: <20100712172640.GD23776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
 <20100712140023.GC25238@ghostprotocols.net>
 <20100712153357.GB23776@linux.vnet.ibm.com>
 <20100712162659.GG25238@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100712162659.GG25238@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Actually we dont need to convert malloc@libc-2.5.so to a
> > malloc@/lib/libc.so.6. Because we can match the shortname of the dso. 
> 
> Humm, I see, it is path based, so the first libc-2.5.so that appears in
> the LD_LIBRARY_PATH equivalent used in this code will be user, is that
> right?

No,  As you might have got it by reading patch 11. I am trying to
reuse the thread/session elements and walk thro the maps in the
map_groups. So I dont need to bother on LD_LIBRARY_PATH.
> 
> I.e. if I'm testing some new libc-2.5.so that provides, say, private
> futexes while the one in my distro still doesn't have this feature, I'll
> have to specify the absolute name or make sure it is before the system's
> libc-2.5.so in the LD_LIBRARY_PATH, right?

We get to the right one, as we walk the list of dsos in the
threadlist. But we have an option of either giving a correct full path
or the shortname for the dso without any path. However right now the
shortname has to be unique i.e I cant use malloc@libc instead of
malloc@libc-2.5.so. I would think specifying full path will be the most
probable usage case. However if a person refers /proc/<pid>/maps,
specifying shortnames should also be easy.

> 
> > Problem will occur when users specifies a full path of the file.
> > Since the file can refer to a symbolic link and the dso will have just
> > the short name or the target file name. Here I am using
> > make_absolute_path to resolve to the target file.
> > Now we can then either check on dso full names or short names.
> > I have chosen to use the short name.
> 
> Humm, so what you want is one of:
> 
> realpath - return the canonicalized absolute pathname
> canonicalize_file_name -  return the canonicalized filename
> 
> Can you please check the man pages for both before we decide
> re-introducing make_absolute_path?

right, realpath is right choice, I will use it instead of this patch. 


--
Thanks and Regards
Srikar

