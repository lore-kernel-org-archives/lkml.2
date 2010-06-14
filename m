Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0FNA1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab0FNA1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:27:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
In-Reply-To: Oleg Nesterov's message of  Wednesday, 2 June 2010 22:38:27 +0200 <20100602203827.GA29244@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com>
	<20100601201843.GA20732@redhat.com>
	<20100602221805.F524.A69D9226@jp.fujitsu.com>
	<20100602154210.GA9622@redhat.com>
	<20100602172956.5A3E34A491@magilla.sf.frob.com>
	<20100602175325.GA16474@redhat.com>
	<20100602185812.4B5894A549@magilla.sf.frob.com>
	<20100602203827.GA29244@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100614002655.35D9E408C1@magilla.sf.frob.com>
Date: Sun, 13 Jun 2010 17:26:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh. This needs more thinking. Definitely the task sleeping in exit_mm()
> must not exit until core_state->dumper->thread returns from do_coredump().
> If nothing else, the dumper can use its task_struct and it relies on
> the stable core_thread->next list. And right now TASK_KILLABLE can't
> work anyway, it is possible that fatal_signal_pending() is true.

Yes, I was right to say this should be another thread.  Let's not get into
all this right now.  I think it is mostly orthogonal to the oom_kill issue.


Thanks,
Roland
