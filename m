Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1BGRhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:37:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1BGRhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:37:21 -0500
Date: Mon, 7 Feb 2011 15:36:53 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Borislav Petkov <borislav.petkov@amd.com>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Kyle McMartin <kyle@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/9] perf/core improvements and fixes
Message-ID: <20110207173653.GC4470@ghostprotocols.net>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
 <20110207150640.GA20053@elte.hu>
 <20110207162916.GB4470@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110207162916.GB4470@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 07, 2011 at 02:29:16PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Feb 07, 2011 at 04:06:40PM +0100, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > Masami Hiramatsu (4):
> > >   perf probe: Add bitfield member support
> > 
> > hm, the perf probe bits do not build on 32-bit:
> > 
> > util/probe-finder.c: In function ‘convert_variable_type’:
> > util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
> > util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
> > make: *** [util/probe-finder.o] Error 1
> > make: *** Waiting for unfinished jobs....
> 
> I already reworked this and force pushed, see:
> 
> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=2b4f8985a2c2309852d20d16d3589eba15b64c4e
> 
> [ committer note: Fixed up '%lu' use for return of die_get_byte_size (int) ]

Argh, I used '%d', which is ok on 32-bit, but then, breaks 64-bit, i.e.
the right format is '%zd' since the expression is '... / sizeof(foo)',
test built on both 64 and 32 bit, this time around it seems final.

Just give it some time to go from master to git.k.o.

- Arnaldo
