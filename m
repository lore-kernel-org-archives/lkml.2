Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1KMNnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:43:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51342 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1KMNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:43:21 -0500
Date: Sun, 13 Nov 2011 11:43:14 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Brian Marete <marete@toshnix.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111113134314.GA2699@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net>
 <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net>
 <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 11, 2011 at 01:01:47AM +0300, Brian Marete escreveu:
> On Thu, Oct 20, 2011 at 4:00 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > I.e. the map_ip for this method is messing up things, what symbol is
> > this? I.e. please provide:

> > p *sym
> > p *map

> I have am experiencing the same segfault using perf from the latest
> linus' tree. The gdb backtrace is below. Which patch fixes it? Or is
> it already fixed in some git tree on kernel.org?

Can you perform this command?

[acme@felicio linux]$ git log | head -1
commit 3439a8da16bcad6b0982ece938c9f8299bb53584

 
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000042e27e in symbol__inc_addr_samples (sym=0x1279e70, map=0x9677a0,
>     evidx=0, addr=256544) at util/annotate.c:73
> 73		h->addr[offset]++;

> # Output of p *sym
> $1 = {rb_node = {rb_parent_color = 19423281, rb_right = 0x0, rb_left = 0x0},
>   start = 1124896, end = 1126163, namelen = 16, binding = 0 '\000',
>   ignore = false, name = 0x1279e70 "1`(\001"}

It is going well before the start of this symbol:

addr(256544) < sym->start(1124896)
 
- Arnaldo
