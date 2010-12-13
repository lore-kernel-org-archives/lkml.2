Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0LMMll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:41:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0LMMlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:41:40 -0500
Subject: Re: perf monitoring triggers Was: Re: [tip:perf/core] perf bench:
 Print both of prefaulted and no prefaulted results by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, yakui.zhao@intel.com, fweisbec@gmail.com,
        ling.ma@intel.com, rostedt@goodmis.org, miaox@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101213123810.GA5407@ghostprotocols.net>
References: <1290668693-27068-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <tip-49ce8fc651794878189fd5f273228832cdfb5be9@git.kernel.org>
	 <4D03B1AD.7000606@dcl.info.waseda.ac.jp>
	 <20101212134657.GA19166@ghostprotocols.net>
	 <1292238873.6803.183.camel@twins>
	 <20101213123810.GA5407@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 13:40:59 +0100
Message-ID: <1292244059.6803.203.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 10:38 -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 13, 2010 at 12:14:33PM +0100, Peter Zijlstra escreveu:
> > On Sun, 2010-12-12 at 11:46 -0200, Arnaldo Carvalho de Melo wrote:
> > > Looks interesting, and also interesting would be to be able to place
> > > probes that would wake up it too, for unmodified binaries to have
> > > something similar.
> 
> > > Other kinds of triggers may be to hook on syscalls and when some
> > > expression matches, like connecting to host 1.2.3.4, start monitoring,
> > > stop when the socket is closed, i.e. monitor a connection lifetime, etc.
>  
> > Sounds to me like you want something like a library with self-monitoring
> > stuff.
> 
> Yeah, that could be a way, an LD_PRELOAD thingy that would intercept
> library calls, setup counters, start a monitoring thread, etc.
> 
> Along the lines of:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/libautocork.git;a=blob;f=libautocork.c
> 
> This one just intercepts calls, but the __init function could do the
> rest.
> 
> To make it easier we could move the counter setup we have in record/top
> to a library, etc.

Nah, I was more thinking of something along the lines of libPAPI and
libpfmon. A library that contains the needed building blocks for apps to
profile themselves.


