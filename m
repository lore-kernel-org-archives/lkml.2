Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0IJJ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab0IJJ05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:26:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
In-Reply-To: KOSAKI Motohiro's message of  Thursday, 9 September 2010 14:31:18 +0900 <20100909141534.C948.A69D9226@jp.fujitsu.com>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<20100908115728.GB11762@grsecurity.net>
	<20100909141534.C948.A69D9226@jp.fujitsu.com>
X-Zippy-Says: C'MON, everybody!!  I've flown in LESLIE GORE and two dozen KOSHER
    BUTCHERS!  They'll be doing intricate MILITARY MANEUVERS to the
    soundtrack from "OKLAHOMA"!!
Message-Id: <20100910092541.2864A405D5@magilla.sf.frob.com>
Date: Fri, 10 Sep 2010 02:25:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Brad, sorry, I have bad news. glibc sysconf(_SC_ARG_MAX) is implemented
> by hard coded RLIMIT_STACK/4 heuristics. That said, at least _now_, we
> can't change this even though you disliked. That said, we can't break
> userland even though userland library is very crazy.

I'm sorry you think it's "very crazy" to implement the required
functionality in the only way available.  POSIX requires that execve
fail with E2BIG when the ARG_MAX limit is exceeded.  sysconf has to
return the correct actual limit that execve will enforce so that a
conforming application knows how much it can safely attempt to use.
Since the kernel uses the hard-coded RLIMIT_STACK/4 heuristic and does
not expose the true manifest limit any other way, sysconf has to
parallel the kernel's calculation.


Thanks,
Roland
