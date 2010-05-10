Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0EJTPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:15:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0EJTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:15:14 -0400
Date: Mon, 10 May 2010 16:15:01 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if
 elfutils is old
Message-ID: <20100510191501.GC19192@ghostprotocols.net>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
 <20100510172854.GD30926@ghostprotocols.net>
 <20100510183654.GH6450@erda.amd.com>
 <4BE8571E.4020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE8571E.4020403@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 10, 2010 at 02:57:34PM -0400, Masami Hiramatsu escreveu:
> Hmm, ok, version.h is also introduced at the same time.
> 
> # git log ./config/version.h.in
> commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
> Author: Roland McGrath <roland@redhat.com>
> Date:   Tue Dec 16 17:03:03 2008 -0800
> 
>     Install elfutils/version.h header for library compatibility checking.
> 
> So, I think we'd better set NO_DWARF if the elfutils
> is older than 0.138, since we can't check API compatibility
> easily.

Well, for that you can just add some of the code you ifdefed in this
patch into the tools/perf/Makefile test, or better, duplicate the test,
including just the CPI stuff in the new test, and then set NO_DWARF_CFI
and use it as the ifdef condition :-)

- Arnaldo
