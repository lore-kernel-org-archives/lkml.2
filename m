Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0IJJoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:44:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54849 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0IJJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:44:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Cc: kosaki.motohiro@jp.fujitsu.com, Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Eugene Teo <eugene@redhat.com>
In-Reply-To: <20100910092541.2864A405D5@magilla.sf.frob.com>
References: <20100909141534.C948.A69D9226@jp.fujitsu.com> <20100910092541.2864A405D5@magilla.sf.frob.com>
Message-Id: <20100910183309.C975.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Sep 2010 18:43:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Brad, sorry, I have bad news. glibc sysconf(_SC_ARG_MAX) is implemented
> > by hard coded RLIMIT_STACK/4 heuristics. That said, at least _now_, we
> > can't change this even though you disliked. That said, we can't break
> > userland even though userland library is very crazy.
> 
> I'm sorry you think it's "very crazy" to implement the required
> functionality in the only way available.  POSIX requires that execve
> fail with E2BIG when the ARG_MAX limit is exceeded.  sysconf has to
> return the correct actual limit that execve will enforce so that a
> conforming application knows how much it can safely attempt to use.
> Since the kernel uses the hard-coded RLIMIT_STACK/4 heuristic and does
> not expose the true manifest limit any other way, sysconf has to
> parallel the kernel's calculation.

Hmm...
Probably my poor english leaded to misunderstood. I didn't intent glibc
is very crazy. I only intended to "even if userland is crazy, I disagree
to break userland".

And yes, we obviously need to expose ARG_MAX limit to libc. a duplicated
heuristic code easily makes confusion and mistake. nobody want such 
fragile state. however, it's a bit offtopic. anyway.


Thanks.

