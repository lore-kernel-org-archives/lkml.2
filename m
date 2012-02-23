Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2BWRhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:37:53 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50212 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BWRhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:37:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arnaldo.melo@gmail.com designates 10.101.136.7 as permitted sender) smtp.mail=arnaldo.melo@gmail.com; dkim=pass header.i=arnaldo.melo@gmail.com
Date: Thu, 23 Feb 2012 15:37:43 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120223173743.GH25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <20120223162850.GC25177@infradead.org>
 <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
 <20120223163938.GD25177@infradead.org>
 <1330015504.13624.84.camel@jaguar>
 <20120223164739.GF25177@infradead.org>
 <20120223165302.GG25177@infradead.org>
 <CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 23, 2012 at 07:10:48PM +0200, Pekka Enberg escreveu:
> On Thu, Feb 23, 2012 at 6:53 PM, Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Em Thu, Feb 23, 2012 at 02:47:39PM -0200, Arnaldo Carvalho de Melo escreveu:
> >> Em Thu, Feb 23, 2012 at 06:45:04PM +0200, Pekka Enberg escreveu:
> >> > How big files are we talking about here?
> >>
> >> 5 MB ones, say.
> >
> > Nah:
> >
> > [root@felicio linux]# perf record -a -F 10000 sleep 5m
> > [ perf record: Woken up 166 times to write data ]
> > [ perf record: Captured and wrote 42.104 MB perf.data (~1839573 samples)
> > ]
> > [root@felicio linux]#
> > [root@felicio linux]#
> > [root@felicio linux]# perf report --gtk
> >
> >  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > 10618 root      20   0  408m 170m  49m S  0.0  2.2   0:04.71 perf
> >
> > [root@felicio linux]# perf report --tui
> >
> > 10633 root      20   0  379m 165m  45m S  0.0  2.1   0:01.15 perf
> 
> Sorry, I don't understand how to interpret your numbers.

I was just gauging how much overhead --gtk had over --tui, for this
specific file VIRT was "just" 29 MB more, which for todays standards is
almost nothing :-)

So just for really, really big files this will make a difference.
 
> I used the same "perf record" command here which generated a 26 MB
> perf.data file. "perf report --gtk" starts up almost instantly here.

Yeah, seems to be OK for most cases, for the ones where it may get in
the way, we can use --tui or --stdio or revisit the providing a callback
for GTK to ask for just the lines it wants rendered.

One thing I saw was that it now defaults to --stdio and then doesn't
setup the pager, i.e. just build it with newt-devel, gtk2-devel
installed and don't specify --gtk to see what I mean.

- Arnaldo
