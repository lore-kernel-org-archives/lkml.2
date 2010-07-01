Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0GAAHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:07:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36669 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0GAAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:07:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 07/11] oom: move OOM_DISABLE check from oom_kill_task to out_of_memory()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100630142034.GF15644@barrios-desktop>
References: <20100630183059.AA5C.A69D9226@jp.fujitsu.com> <20100630142034.GF15644@barrios-desktop>
Message-Id: <20100701090228.DA1C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Jul 2010 09:07:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 30, 2010 at 06:31:36PM +0900, KOSAKI Motohiro wrote:
> > Now, if oom_kill_allocating_task is enabled and current have
> > OOM_DISABLED, following printk in oom_kill_process is called twice.
> > 
> >     pr_err("%s: Kill process %d (%s) score %lu or sacrifice child\n",
> >             message, task_pid_nr(p), p->comm, points);
> > 
> > So, OOM_DISABLE check should be more early.
> 
> If we check it in oom_unkillable_task, we don't need this patch. 

Yup. but please read the commnet of [3/11].



