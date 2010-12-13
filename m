Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab0LMLPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:15:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:50093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab0LMLPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:15:52 -0500
Subject: Re: perf monitoring triggers Was: Re: [tip:perf/core] perf bench:
 Print both of prefaulted and no prefaulted results by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, yakui.zhao@intel.com, fweisbec@gmail.com,
        ling.ma@intel.com, rostedt@goodmis.org, miaox@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu, acme@ghostprotocols.net
In-Reply-To: <20101212134657.GA19166@ghostprotocols.net>
References: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <tip-49ce8fc651794878189fd5f273228832cdfb5be9@git.kernel.org>
	 <4D03B1AD.7000606@dcl.info.waseda.ac.jp>
	 <20101212134657.GA19166@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 12:14:33 +0100
Message-ID: <1292238873.6803.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 11:46 -0200, Arnaldo Carvalho de Melo wrote:
> Em Sun, Dec 12, 2010 at 02:15:25AM +0900, Hitoshi Mitake escreveu:
> > BTW, I found that measuring performance of prefaulted memcpy()
> > with perf stat is difficult. Because current perf stat monitors
> > whole execution of program or range of perf stat lifetime.
> 
> > If perf stat and monitored program can interact and work
> > synchronously, it will be better.
> 
> > For example, if perf stat waits on the unix domain socket
> > before create_perf_stat_counter() and monitored program wakes perf stat
> > up through the socket, more fine grain monitoring will be possible.
> 
> > I imagine the execution will be like this:
> > perf stat --wait-on /tmp/perf_wait perf bench mem memcpy --wake-up  
> > /tmp/perf_wait
> 
> > --wait-on is imaginaly option of perf stat, and the way of waking up
> > perf stat is left to monitored program (in this case, --wake-up is
> > used for specifying the name of the socket).
> 
> > I'd like to implement such a option to perf stat, how do you think?
> 
> Looks interesting, and also interesting would be to be able to place
> probes that would wake up it too, for unmodified binaries to have
> something similar.
> 
> Other kinds of triggers may be to hook on syscalls and when some
> expression matches, like connecting to host 1.2.3.4, start monitoring,
> stop when the socket is closed, i.e. monitor a connection lifetime, etc.
> 
> I think it is worth pursuing and encourage you to work on it :-)

Sounds to me like you want something like a library with self-monitoring
stuff.
