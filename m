Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2BWQxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:53:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58673 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2BWQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:53:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.101.2.7 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Thu, 23 Feb 2012 14:53:02 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120223165302.GG25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <20120223162850.GC25177@infradead.org>
 <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
 <20120223163938.GD25177@infradead.org>
 <1330015504.13624.84.camel@jaguar>
 <20120223164739.GF25177@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223164739.GF25177@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 23, 2012 at 02:47:39PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Feb 23, 2012 at 06:45:04PM +0200, Pekka Enberg escreveu:
> > On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> > > > Dunno, probably. Does that matter, though? It's pretty damn fast as-is.
> > > 
> > > Well, what kinds of perf.data file are you feeding it?
> > 
> > It's a real-world case where I'm profiling JRuby startup under Jato with
> > perf:
> > 
> > penberg@jaguar:~/src/jato$ ls -lh perf.data 
> > -rw------- 1 penberg penberg 453K 2012-02-23 18:06 perf.data
> > 
> > On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
> > > I'm testing it now with large ones, lets see.
> > 
> > How big files are we talking about here?
> 
> 5 MB ones, say.

Nah:

[root@felicio linux]# perf record -a -F 10000 sleep 5m
[ perf record: Woken up 166 times to write data ]
[ perf record: Captured and wrote 42.104 MB perf.data (~1839573 samples)
]
[root@felicio linux]# 
[root@felicio linux]# 
[root@felicio linux]# perf report --gtk

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                                                           
10618 root      20   0  408m 170m  49m S  0.0  2.2   0:04.71 perf

[root@felicio linux]# perf report --tui

10633 root      20   0  379m 165m  45m S  0.0  2.1   0:01.15 perf
 
> But the way you did it is pretty minimalistic, which is good, its just
> that I don't really like the idea of having two mirror data structures
> representing the report lines.

- Arnaldo
