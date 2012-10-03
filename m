Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2JCQSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:18:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43393 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2JCQSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:22 -0400
Date: Wed, 3 Oct 2012 18:18:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121003161816.GG16230@one.firstfloor.org>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com> <20120927213102.GO16230@one.firstfloor.org> <20121001081631.GB991@krava.brq.redhat.com> <20121002163002.GD16230@one.firstfloor.org> <20121003134757.GA18700@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003134757.GA18700@ghostprotocols.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 06:47:57AM -0700, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 02, 2012 at 06:30:02PM +0200, Andi Kleen escreveu:
> > The other problem I ran into is that perf archive doesn't seem to work very
> > well with kernels, so it's hard to move profiles from different kernels
> > around to diff them (e.g. for a performance regression) One way around this
> > would be options to diff to specify the vmlinux etc.  manually
> 
> Can you describe more precisely what is not working well with 'archive'
> and build ids?

It doesn't write anything to anywhere for me

It also breaks with different perf binaries because it seems to just
do system("perf ...") at some point. This may be related to this.

And synching .cache is a quite clumpsy way even if it worked.

% strace -f -e open -o log perf archive
% grep WR log
20041 open("/dev/tty", O_RDWR|O_NONBLOCK) = 3
20042 open("/tmp/perf-archive-buildids.5uDTJ2", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
20044 open("/tmp/perf-archive-buildids.5uDTJ2", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
20045 open("/tmp/perf-archive-manifest.jRy7nP", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
20047 open("/tmp/perf-archive-manifest.jRy7nP", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
20047 open("/tmp/perf-archive-manifest.jRy7nP", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
20047 open("/tmp/perf-archive-manifest.jRy7nP", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
20047 open("/tmp/perf-archive-manifest.jRy7nP", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
% 

-Andi
