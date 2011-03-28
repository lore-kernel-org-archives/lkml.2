Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1C1JsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:48:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35066 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1C1JsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:48:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/5] Revert "oom: give the dying task a higher priority"
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110324152757.GC1938@barrios-desktop>
References: <20110322200657.B064.A69D9226@jp.fujitsu.com> <20110324152757.GC1938@barrios-desktop>
Message-Id: <20110328184856.F078.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 28 Mar 2011 18:48:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> @@ -434,9 +452,17 @@ static int oom_kill_task(struct task_struct *p)
>                 K(get_mm_counter(p->mm, MM_FILEPAGES)));
>         task_unlock(p);
>  
> -       p->rt.time_slice = HZ; <<---- THIS
> +
>         set_tsk_thread_flag(p, TIF_MEMDIE);
>         force_sig(SIGKILL, p);
> +
> +       /*
> +        * We give our sacrificial lamb high priority and access to
> +        * all the memory it needs. That way it should be able to
> +        * exit() and clear out its resources quickly...
> +        */
> +       boost_dying_task_prio(p, mem);
> +
>         return 0;
>  }
> 
> At that time, I thought that routine is meaningless in non-RT scheduler.
> So I Cced Peter but don't get the answer.
> I just want to confirm it.
> 
> Do you still think it's meaningless? 

In short, yes.


> so you remove it when you revert 93b43fa5508?
> Then, this isn't just revert patch but revert + killing meaningless code patch.

If you want, I'd like to rename a patch title. That said, we can't revert
93b43fa5508 simple cleanly, several patches depend on it. therefore I
reverted it manualy. and at that time, I don't want to resurrect
meaningless logic. anyway it's no matter. Luis is preparing new patches.
therefore we will get the same end result. :)



