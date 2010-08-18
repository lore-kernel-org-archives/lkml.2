Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0HRRCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:02:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0HRRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:02:06 -0400
Date: Wed, 18 Aug 2010 14:01:58 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Bernd Petrovitsch <bernd@sysprog.at>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100818170158.GG9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
 <20100818123713.1F02414C03B@msa103.auone-net.jp>
 <1282135224.1926.3936.camel@laptop>
 <20100818141611.GE9410@ghostprotocols.net>
 <1282141665.1926.4053.camel@laptop>
 <20100818165642.GF9410@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818165642.GF9410@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 18, 2010 at 01:56:42PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Aug 18, 2010 at 04:27:45PM +0200, Peter Zijlstra escreveu:
> > On Wed, 2010-08-18 at 11:16 -0300, Arnaldo Carvalho de Melo wrote:
> > > rm -rf ~/build
> > > make O=~/build
> > > 
> > > and have everything work? Saving some keystrokes 8)
> > 
> > The turn side is that if you typo the output dir you'll probably not
> > ever find it again.. and you could have typed: rm -rf ~/build/* instead.
> 
> Not something I'll argue too much :)
> 
> I'll apply the patch as it fixes a bug and later make the perf Makefile
> complain about the output dir not existing, i.e. providing a message
> similar to what the kernel proper does instead of the cryptic message we
> get today.

[acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
[acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -C tools/perf 
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
Makefile:503: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
Makefile:534: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop.
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
[acme@emilia linux-2.6-tip]$

- Arnaldo
