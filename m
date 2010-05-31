Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0EaXGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:06:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0EaXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:06:52 -0400
Date: Mon, 31 May 2010 20:06:39 -0300
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
Message-ID: <20100531230639.GD3481@ghostprotocols.net>
References: <20100528185357.GA28009@ghostprotocols.net>
 <20100529072948.GE16257@merkur.ravnborg.org>
 <20100531174207.GB3481@ghostprotocols.net>
 <4C0417EC.8050906@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0417EC.8050906@suse.cz>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 31, 2010 at 10:11:24PM +0200, Michal Marek escreveu:
> On 31.5.2010 19:42, Arnaldo Carvalho de Melo wrote:
> > +git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
> 
> If you use plain "HEAD" (a commit-ish) instead if HEAD^{tree}, then
> git archive will store the commit id in the archive metadata and the
> user can then use git get-tar-commit-id to extract it.

I just used what was in git.git and then when talking with a git
enthusiast, he showed me this:

[acme@emilia git]$ git show 9cd625b79babaf50f50a0e5d96903eaacb1ee600
commit 9cd625b79babaf50f50a0e5d96903eaacb1ee600
Author: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
Date:   Sun Jun 18 15:25:33 2006 +0200

    Make release tarballs friendlier to older tar versions
    
    git-tar-tree adds an extended pax header to archives if its first
    parameter points to a commit.  It confuses older tars and isn't
    very useful in the case of git anyway, so stop doing it.
    
    Idea: Junio, implementation: Junio.  I just wrote it up. :-)
    
    Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
    Signed-off-by: Junio C Hamano <junkio@cox.net>

diff --git a/Makefile b/Makefile
index 2a1e639..28517f4 100644
--- a/Makefile
+++ b/Makefile
@@ -667,7 +667,7 @@ git.spec: git.spec.in
 
 GIT_TARNAME=git-$(GIT_VERSION)
 dist: git.spec git-tar-tree
-       ./git-tar-tree HEAD $(GIT_TARNAME) > $(GIT_TARNAME).tar
+       ./git-tar-tree HEAD^{tree} $(GIT_TARNAME) > $(GIT_TARNAME).tar
        @mkdir -p $(GIT_TARNAME)
        @cp git.spec $(GIT_TARNAME)
        @echo $(GIT_VERSION) > $(GIT_TARNAME)/version
[acme@emilia git]$

We definetely want to have this working with old installations.
 
> > +	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
> > +mkdir -p $(perf-tar);                                               \
> > +git rev-parse HEAD > $(perf-tar)/HEAD;                              \
> > +tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
> 
> ... then this HEAD file might not even be necessary (even if you keep
> it, it would be nice not to break git get-tar-commit-id).

Well, what about the other aspects of the patch, is this the only issue
you have found with it?

- Arnaldo
