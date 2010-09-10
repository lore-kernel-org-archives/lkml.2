Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0IJJkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0IJJkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:40:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu, Brad Spengler <spender@grsecurity.net>,
        Eugene Teo <eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] oom: don't ignore rss in nascent mm
In-Reply-To: Oleg Nesterov's message of  Friday, 10 September 2010 00:05:04 +0200 <20100909220504.GA6273@redhat.com>
References: <20100908023417.8B055401AF@magilla.sf.frob.com>
	<20100909134842.C93F.A69D9226@jp.fujitsu.com>
	<20100909140219.C942.A69D9226@jp.fujitsu.com>
	<20100909220504.GA6273@redhat.com>
X-Windows: putting new limits on productivity.
Message-Id: <20100910093958.143B5405D5@magilla.sf.frob.com>
Date: Fri, 10 Sep 2010 02:39:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if it makes sense to move ->cred_guard_mutex from task_struct
> to signal_struct and thus make multiple-threads-inside-exec impossible.
> Only one thread can win anyway.

That probably makes sense.  Note that cred_guard_mutex is also overloaded
for ptrace_attach, so this would add some more serialization of attaches to
threads in the same group.  But as long as actual attachment serializes on
tasklist_lock anyway, it doesn't make a material difference.  (Even without
that, it would presumably be the same debugger attaching serially to
threads in the same group, so it wouldn't degrade anything in practice.)


Thanks,
Roland
