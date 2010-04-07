Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab0DGKjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 06:39:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34753 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab0DGKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 06:39:09 -0400
Date: Wed, 7 Apr 2010 07:38:55 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Floating point exception by perf record
Message-ID: <20100407103855.GC3908@ghostprotocols.net>
References: <4BB84991.5080301@dcl.info.waseda.ac.jp>
 <20100405183127.GA3677@ghostprotocols.net>
 <4BBC4318.1070702@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBC4318.1070702@dcl.info.waseda.ac.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 07, 2010 at 05:32:24PM +0900, Hitoshi Mitake escreveu:
> On 04/06/10 03:31, Arnaldo Carvalho de Melo wrote:
> > Em Sun, Apr 04, 2010 at 05:10:57PM +0900, Hitoshi Mitake escreveu:
> > [root@doppio ~]# perf lock report | head -3
> >    Warning: Error: expected 'data' but read 'overwrite'
> >                  ID                 Name   acquired  contended
> total wait (ns)   max wait (ns)   min wait (ns)
> >
> > 0xffff8800029d4b28&q->lock          0          0               0
> 0               0
> > [root@doppio ~]#
> >
> > My system details:
> >
> > [root@doppio ~]# uname -a
> > Linux doppio.ghostprotocols.net 2.6.34-rc3-tip+ #1 SMP Mon Apr 5
> 13:49:42 BRT 2010 x86_64 x86_64 x86_64 GNU/Linux
> > [root@doppio ~]# rpm -q newt
> > newt-0.52.10-4.fc11.x86_64
> > [root@doppio ~]#
> >
> > No segfaults here :-\
> >
> > - Arnaldo
> >
> 
> I tested perf lock trace and got a similar error (but different).
> % sudo ./perf lock trace
>   Fatal: reading input file (size expected=3 received=0)
> It seems that perf.data is broken :( I'll search the cause.

Take a look at:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=summary

"perf" branch, there is at least one fix there, the "overwrite" one.

- Arnaldo
