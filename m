Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab2JCQxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:53:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43431 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2JCQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:53:44 -0400
Date: Wed, 3 Oct 2012 18:53:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121003165342.GH16230@one.firstfloor.org>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com> <20120927213102.GO16230@one.firstfloor.org> <20121001081631.GB991@krava.brq.redhat.com> <20121002163002.GD16230@one.firstfloor.org> <20121003134757.GA18700@ghostprotocols.net> <20121003161816.GG16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003161816.GG16230@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 06:18:16PM +0200, Andi Kleen wrote:
> On Wed, Oct 03, 2012 at 06:47:57AM -0700, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Oct 02, 2012 at 06:30:02PM +0200, Andi Kleen escreveu:
> > > The other problem I ran into is that perf archive doesn't seem to work very
> > > well with kernels, so it's hard to move profiles from different kernels
> > > around to diff them (e.g. for a performance regression) One way around this
> > > would be options to diff to specify the vmlinux etc.  manually
> > 
> > Can you describe more precisely what is not working well with 'archive'
> > and build ids?
> 
> It doesn't write anything to anywhere for me
> 
> It also breaks with different perf binaries because it seems to just
> do system("perf ...") at some point. This may be related to this.


The problem is with the perf-archive script. After some hacking I got it running
now. I suspect the perf tool needs to pass its own executable name to
the script to run.

Also would be nice if another file than perf.data could be specified
(currently have to symlink)

-Andi
