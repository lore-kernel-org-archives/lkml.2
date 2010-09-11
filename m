Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0IKNkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:40:13 -0400
Received: from r00tworld.com ([212.85.137.21]:37925 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0IKNkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:40:11 -0400
From: pageexec@freemail.hu
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Date: Sat, 11 Sep 2010 15:39:30 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Reply-to: pageexec@freemail.hu
CC: Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, Eugene Teo <eugene@redhat.com>
Message-ID: <4C8B8692.7649.3E0895B@pageexec.freemail.hu>
In-reply-to: <20100910092541.2864A405D5@magilla.sf.frob.com>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>, <KOSAKI Motohiro's message of  Thursday, 9 September 2010 14:31:18 +0900 <20100909141534.C948.A69D9226@jp.fujitsu.com>>, <20100910092541.2864A405D5@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Sat, 11 Sep 2010 15:39:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Sep 2010 at 2:25, Roland McGrath wrote:

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

no it doesn't have to, similarly to how it doesn't have to hardcode
_SC_PAGESIZE either, AT_PAGESZ tells userland what it needs to know
and i think AT_ARGMAX could exist just as well.

