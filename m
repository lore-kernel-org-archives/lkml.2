Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0LADEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:04:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57386 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0LADEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:04:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] exec: copy-and-paste the fixes into compat_do_execve() paths
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, stable@kernel.org
In-Reply-To: <20101130195602.GC11905@redhat.com>
References: <20101130195456.GA11905@redhat.com> <20101130195602.GC11905@redhat.com>
Message-Id: <20101201120530.ABB6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 12:04:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note: this patch targets 2.6.37 and tries to be as simple as possible.
> That is why it adds more copy-and-paste horror into fs/compat.c and
> uglifies fs/exec.c, this will be cleanuped later.
> 
> compat_copy_strings() plays with bprm->vma/mm directly and thus has
> two problems: it lacks the RLIMIT_STACK check and argv/envp memory
> is not visible to oom killer.
> 
> Export acct_arg_size() and get_arg_page(), change compat_copy_strings()
> to use get_arg_page(), change compat_do_execve() to do acct_arg_size(0)
> as do_execve() does.
> 
> Add the fatal_signal_pending/cond_resched checks into compat_count() and
> compat_copy_strings(), this matches the code in fs/exec.c and certainly
> makes sense.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



