Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0GaTa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:30:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:42531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0GaTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:30:57 -0400
Date: Sat, 31 Jul 2010 16:30:19 -0300
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
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
Message-ID: <20100731193019.GE12166@ghostprotocols.net>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
 <20100730191903.GD12166@ghostprotocols.net>
 <20100731025748.GA22812@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100731025748.GA22812@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jul 31, 2010 at 08:27:48AM +0530, Srikar Dronamraju escreveu:
> > > @@ -1598,15 +1812,19 @@ struct __event_package {
> > >  int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
> > >  			  bool force_add, int max_tevs)
> > >  {
> > > -	int i, j, ret;
> > > +	int i, j, ret = 0;
> > >  	struct __event_package *pkgs;
> > >  
> > >  	pkgs = zalloc(sizeof(struct __event_package) * npevs);
> > >  	if (pkgs == NULL)
> > >  		return -ENOMEM;
> > >  
> > > -	/* Init vmlinux path */
> > > -	ret = init_vmlinux();
> > > +	if (!pevs->upid)
> > > +		/* Init vmlinux path */
> > > +		ret = init_vmlinux();
> > > +	else
> > > +		ret = init_perf_uprobes();
> > > +
> > >  	if (ret < 0)
> > 
> > pkgs leaks here.
> 
> Right, but I dont think this leak was introduced by my patch(s). I
> guess its better fixed by a different patch. 

Sorry, will fix that then on a separate patch.

- Arnaldo
