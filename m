Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1AQMIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 07:08:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:36279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1AQMH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 07:07:59 -0500
Date: Mon, 17 Jan 2011 10:07:21 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [PATCH -perf/perf/core  5/6] perf probe: Add variable filter
	support
Message-ID: <20110117120721.GB3902@ghostprotocols.net>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp> <20110113124624.22426.72527.stgit@ltc236.sdl.hitachi.co.jp> <m3wrm87ba7.fsf@gmail.com> <4D2FB7FD.3020004@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2FB7FD.3020004@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 14, 2011 at 11:42:05AM +0900, Masami Hiramatsu escreveu:
> (2011/01/14 6:18), Franck Bui-Huu wrote:
> > I'm wondering if the different syntax below could be simpler:
> > 
> >    $ perf probe add <probe>
> >    $ perf probe del <probe>
> >    $ perf probe show       
> >    $ perf probe list <line>
> >            ...       --vars[=<pattern>] [--externs] <probe>
> >            ...       --funcs[=<pattern>]
 
> Hm, well, if no one complains about changing the syntax of perf probe,
> it may make things simple (maybe we'll also have to drop "perf probe
> <PROBE>" syntax). Nowadays we already have perf-kvm, perf-sched, etc.
> which use sub-sub commands.
 
> IMHO, for avoiding confusion old options and "perf-list", below
> sub-sub commands are more suitable.
 
>    $ perf probe add <probe>
>    $ perf probe del <probe>
>    $ perf probe list
>    $ perf probe lines <line>
>    $ perf probe vars [--filter=<pattern>|-F <pattern>] [--extern] <probe>
>    $ perf probe funcs [--filter=<pattern>|-F <pattern>]

Right, and when packaging, we can do just like Ingo and Thomas are doing
with 'perf trace', create a hardlink and if argv[0] is 'probe', that is
an alias to 'perf probe', so we would do it just like:

$ probe add <probe>
$ probe del <probe>
$ probe list
$ probe lines <line>
$ probe vars [--filter=<pattern>|-F <pattern>] [--extern] <probe>
$ probe funcs [--filter=<pattern>|-F <pattern>]

[root@felicio ~]# probe
bash: probe: command not found...

Also google told me that there was an /sbin/probe utility, but that was
a long time ago, in the kernel-pcmcia-cs package, nowadays we have
pcmciautils and it doesn't have this command, so I think it is up for
grabs :-)

So I think that the 'probe funcs' makes sense, will apply that patch in
perf/core.

- Arnaldo
