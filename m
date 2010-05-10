Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0EJS5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:57:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0EJS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:57:51 -0400
Date: Mon, 10 May 2010 15:57:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if
 elfutils is old
Message-ID: <20100510185729.GB19192@ghostprotocols.net>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
 <20100510172854.GD30926@ghostprotocols.net>
 <20100510183654.GH6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510183654.GH6450@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 10, 2010 at 08:36:54PM +0200, Robert Richter escreveu:
> On 10.05.10 13:28:54, Arnaldo Carvalho de Melo wrote:
> > Em Mon, May 10, 2010 at 01:12:07PM -0400, Masami Hiramatsu escreveu:
> > > Check elfutils version, and if it is old don't compile CFI
> > > analysis code. This allows to compile perf with old elfutils.

> > _ELFUTILS_PREREQ was introduced in:

> > commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
> > Author: Roland McGrath <roland@redhat.com>
> > Date:   Tue Dec 16 17:03:03 2008 -0800

> > Which was released in elfutils 0.138, guess this is coverage enough?
> > Richard, which version is in your machine?

> Right, this does not work, I am using 0.131. As expected,
> "_ELFUTILS_PREREQ" is not defined:

> util/probe-finder.h:47:5: error: "_ELFUTILS_PREREQ" is not defined
> util/probe-finder.h:47:21: error: missing binary operator before token "("
> make: *** [builtin-probe.o] Error 1

> Why not create a compile test as for NO_DWARF in tools/perf/Makefile?

Right, that would be better.

- Arnaldo
