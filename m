Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab0HQPnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:43:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab0HQPnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:43:05 -0400
Date: Tue, 17 Aug 2010 12:42:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Bernd Petrovitsch <bernd@sysprog.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
Message-ID: <20100817154237.GG13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp> <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop> <1281970478.17267.12.camel@thorin> <20100816152914.GC13095@ghostprotocols.net> <1281973427.17267.16.camel@thorin> <20100816155022.GD13095@ghostprotocols.net> <1282046280.5822.4.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282046280.5822.4.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 17, 2010 at 01:58:00PM +0200, Bernd Petrovitsch escreveu:
> On Mon, 2010-08-16 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Aug 16, 2010 at 05:43:47PM +0200, Bernd Petrovitsch escreveu:
> > > On Mon, 2010-08-16 at 12:29 -0300, Arnaldo Carvalho de Melo wrote:
> > > > More seriously, so there is a reason for that to be like that and you're
> > > > not aware of any other shorter or more convenient way of achieving that
> > 
> > > One (obvious) alternative is to have rules triggering on the
> > > non-existence of these directories.
> > 
> > Can you provide those please?
> [...]
> > Right, not enough, what those mkdir calls were added for was exactly for
> > a different usecase:
> > 
> > make -C tools/perf -O=~/build/perf/
> 
> Thanks.
> 
> The following patch below at the end works for me. Alas, it is against
> vanilla main line.

Adding $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h there, to have it look:

+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+$(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h: $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS))):
+       mkdir -p $@ 2>/dev/null
+

As it was failing when I did:

rm -rf ~/build/perf
make -C tools/perf O=~/build/perf

With that it retains the existing functionality,

Thanks,

- Arnaldo
