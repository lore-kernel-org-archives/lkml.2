Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0FABBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:01:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58633 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0FABBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:01:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Jun 2010 09:57:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] oom: introduce find_lock_task_mm() to fix !mm false
 positives
Message-Id: <20100601095727.9ba3e108.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100531183539.1849.A69D9226@jp.fujitsu.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com>
	<20100531183539.1849.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 18:36:34 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> From: Oleg Nesterov <oleg@redhat.com>
> Subject: [PATCH 3/5] oom: introduce find_lock_task_mm() to fix !mm false positives
> 
> Almost all ->mm == NUL checks in oom_kill.c are wrong.
> 
> The current code assumes that the task without ->mm has already
> released its memory and ignores the process. However this is not
> necessarily true when this process is multithreaded, other live
> sub-threads can use this ->mm.
> 
> - Remove the "if (!p->mm)" check in select_bad_process(), it is
>   just wrong.
> 
> - Add the new helper, find_lock_task_mm(), which finds the live
>   thread which uses the memory and takes task_lock() to pin ->mm
> 
> - change oom_badness() to use this helper instead of just checking
>   ->mm != NULL.
> 
> - As David pointed out, select_bad_process() must never choose the
>   task without ->mm, but no matter what badness() returns the
>   task can be chosen if nothing else has been found yet.
> 
> Note! This patch is not enough, we need more changes.
> 
> 	- badness() was fixed, but oom_kill_task() still ignores
> 	  the task without ->mm
> 
> This will be addressed later.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [rebase
> latest -mm and remove some obsoleted description]

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


