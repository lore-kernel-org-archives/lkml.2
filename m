Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0FAUYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:24:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:39200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0FAUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:24:13 -0400
Date: Tue, 1 Jun 2010 17:23:40 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [BUG] perf: buildid not managed properly when cmd path is
 relative
Message-ID: <20100601202340.GE4093@ghostprotocols.net>
References: <AANLkTimTMDjP3fgcOv2kIUPYYONAiMYPdhDb1VsLrTE_@mail.gmail.com>
 <20100601183837.GC4093@ghostprotocols.net>
 <AANLkTinpaxSIEmqetcXDZIRdLUT7IuVPGInwTqN9F5cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpaxSIEmqetcXDZIRdLUT7IuVPGInwTqN9F5cQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 01, 2010 at 10:05:24PM +0200, Stephane Eranian escreveu:
> Hi,
> 
> You patch does seem to fix the problem.

thanks for confirming.
 
> However, I think there may be another issue, maybe
> caused by the patch.
> 
> If you monitor a program WITHOUT buildids, and you run
> 
> $ perf record tmp/foo
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.077 MB perf.data (~3370 samples) ]
> 
> $  ./perf buildid-list
> 86200ab2bca285344a55156a079debbbe172bcc5 [kernel.kallsyms]
> 
> foo does not appear, yet we know it got samples.
> 
> $ ./perf buildid-list --with-hits
> 86200ab2bca285344a55156a079debbbe172bcc5 [kernel.kallsyms]
> 0000000000000000000000000000000000000000 /home/eranian/tmp/foo
> 
> With the --with-hits option, I get more output than without.Supposedly
> no option means 'prints all entries', including those with hits or
> without buildids.

Right, I noticed that too, but concentrated on fixing the problem that
was clearly a bug, will add this to my TODO list as I agree this is
inconsistent and/or incomplete behaviour.

Will add a Tested-by: you and push it to Ingo via perf/urgent.

Thanks for testing,

- Arnaldo
