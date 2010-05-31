Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab0EaXtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:49:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55275 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0EaXtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:49:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/5] oom: the points calculation of child processes must use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100531165658.GC9991@redhat.com>
References: <20100531183636.184C.A69D9226@jp.fujitsu.com> <20100531165658.GC9991@redhat.com>
Message-Id: <20100601084807.242D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 08:48:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And, I think we need another patch on top of this one. Note that
> this list_for_each_entry(p->children) can only see the tasks forked
> by p, it can't see other children forked by its sub-threads.
> 
> IOW, we need
> 
> 	do {
> 		list_for_each_entry(c, &t->children, sibling) {
> 			...
> 		}
> 	} while_each_thread(p, t);
> 
> Probably the same for oom_kill_process().
> 
> What do you think?

Makes perfectly sense. I have to do it!

Thanks good reviewing!




