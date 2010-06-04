Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab0FDRgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:36:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0FDRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:36:14 -0400
Date: Fri, 4 Jun 2010 14:35:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] perf tools: Make target to generate self
 contained source tarball
Message-ID: <20100604173552.GA875@ghostprotocols.net>
References: <20100528185357.GA28009@ghostprotocols.net>
 <20100529072948.GE16257@merkur.ravnborg.org>
 <20100531174207.GB3481@ghostprotocols.net>
 <4C0417EC.8050906@suse.cz>
 <20100531230639.GD3481@ghostprotocols.net>
 <4C04E0EA.8010100@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C04E0EA.8010100@suse.cz>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 01, 2010 at 12:28:58PM +0200, Michal Marek escreveu:
> On 1.6.2010 01:06, Arnaldo Carvalho de Melo wrote:
> > Well, what about the other aspects of the patch, is this the only issue
> > you have found with it?
> 
> The patch is OK.
> 
> Acked-by: Michal Marek <mmarek@suse.cz>

Argh, there was one last detail, so that we don't require that the
kernel be configured first, and as we don't use KERNELRELEASE at all in
the -src-pkg targets, would that be OK with you too?

[acme@emilia linux-2.6-tip]$ git diff Makefile 
diff --git a/Makefile b/Makefile
index 0ab0c6f..6e186a1 100644
--- a/Makefile
+++ b/Makefile
@@ -1215,6 +1215,8 @@ distclean: mrproper
 # rpm target kept for backward compatibility
 package-dir    := $(srctree)/scripts/package
 
+%src-pkg: FORCE
+       $(Q)$(MAKE) $(build)=$(package-dir) $@
 %pkg: include/config/kernel.release FORCE
        $(Q)$(MAKE) $(build)=$(package-dir) $@
 rpm: include/config/kernel.release FORCE
[acme@emilia linux-2.6-tip]$

On a make mrproper'ed kernel we get:

a linux-2.6-tip]$ LANG= make perf-tarbz2-src-pkg
/bin/sh: include/config/kernel.release: No such file or directory
make: *** [include/config/kernel.release] Error 1
[acme@emilia linux-2.6-tip]$

:-\

If you're ok with it, I'll add it as a follow on patch that I'll send
via Ingo.

- Arnaldo
