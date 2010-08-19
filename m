Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0HSJCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:02:36 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3707 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab0HSJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:02:34 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7J92BbP012823
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818190959.GI9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
	 <20100818123713.1F02414C03B@msa103.auone-net.jp>
	 <1282135224.1926.3936.camel@laptop>
	 <20100818141611.GE9410@ghostprotocols.net>
	 <1282141665.1926.4053.camel@laptop>
	 <20100818165642.GF9410@ghostprotocols.net>
	 <20100818170158.GG9410@ghostprotocols.net>
	 <20100818190959.GI9410@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 11:02:10 +0200
Message-ID: <1282208530.10440.3.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-08-18 at 16:09 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 18, 2010 at 02:01:58PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Aug 18, 2010 at 01:56:42PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Wed, Aug 18, 2010 at 04:27:45PM +0200, Peter Zijlstra escreveu:
> > > > On Wed, 2010-08-18 at 11:16 -0300, Arnaldo Carvalho de Melo wrote:
> > > > > rm -rf ~/build
> > > > > make O=~/build
> > > > > 
> > > > > and have everything work? Saving some keystrokes 8)
> > > > 
> > > > The turn side is that if you typo the output dir you'll probably not
> > > > ever find it again.. and you could have typed: rm -rf ~/build/* instead.

Well, usually interactive shells have a history. But since the other
Makefiles also expect existing destination top directory ...

> > > Not something I'll argue too much :)
> 
> Ok, here it is, stolen directly from the toplevel kernel Makefile, will push to

ACK, it's the same problem so the same solution is the best.

> Ingo today:
> 
> [acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf
> [acme@emilia linux-2.6-tip]$ make -j9 O=~/git/build/perf -C tools/perf
> /bin/sh: line 0: cd: /home/acme/git/build/perf/: No such file or directory

ACK, that should make the "problem" pretty clear.

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

