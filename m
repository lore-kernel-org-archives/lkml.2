Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2EDNhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:37:04 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57327 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2EDNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:37:02 -0400
Date: Fri, 4 May 2012 10:37:06 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
Message-ID: <20120504133706.GA10068@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
 <4F996433.7040003@gmail.com>
 <1335474778.1497.14.camel@leonhard>
 <4F99BCAF.1080309@gmail.com>
 <87397qhvvx.fsf@sejong.aot.lge.com>
 <20120502184033.GD5745@infradead.org>
 <87fwbga8v7.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwbga8v7.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 04, 2012 at 01:05:48PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> On Wed, 2 May 2012 15:40:33 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Apr 27, 2012 at 09:16:18AM +0900, Namhyung Kim escreveu:
> >> So as long as you set perf_event_paranoid to -1 or run perf test as
> >> root, you cannot see the failure.
> >
> > Ok, as root try 'perf top', here I get, with this patch:
> >
> > [root@sandy ~]# perf top --stdio
> > Warning:
> > The sys_perf_event_open() syscall returned with 22 (Invalid argument).
> > /bin/dmesg may provide additional information.
> > No CONFIG_PERF_EVENTS=y kernel support configured?
> > [root@sandy ~]#
> >
> > Skipping this one, will look again later.
> >
> > - Arnaldo
> 
> Sorry. It is because perf top depends on an undefined behaviour that
> if neither target nor command line argument was specified it'd open
> events for all online cpus. In contrast, perf record and perf stat will
> show the help message in this case.
> 
> This patch makes it clear that we have to prepare a sane target
> configuration before opening a perf event fd. So I think we should fix
> perf top to set top.target.system_wide to true by default.

So please provide a preparatory patch for top before this one, ok?

- Arnaldo
