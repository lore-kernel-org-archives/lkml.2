Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0FULpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:45:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab0FULpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:45:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/9] oom: oom_kill_process() need to check p is unkillable
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1006162118520.14101@chino.kir.corp.google.com>
References: <20100617104647.FB89.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006162118520.14101@chino.kir.corp.google.com>
Message-Id: <20100617135224.FBAA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 21 Jun 2010 20:45:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> 
> > When oom_kill_allocating_task is enabled, an argument task of
> > oom_kill_process is not selected by select_bad_process(), It's
> > just out_of_memory() caller task. It mean the task can be
> > unkillable. check it first.
> > 
> 
> This should be unnecessary if oom_kill_process() appropriately returns 
> non-zero when it cannot kill a task.  What problem are you addressing with 
> this fix?

oom_kill_process() only check its children are unkillable, not its own.
To add check oom_kill_process() also solve the issue. as my previous patch does.
but Minchan pointed out it's unnecessary. because when !oom_kill_allocating_task
case, we have the same check in select_bad_process(). 



