Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0C1Cq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 22:46:26 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0C1CqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 22:46:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=e3g359yw0VoNODmt1E6FrJR3wo++pvdmy6PHBaotkpvefEw+fkgUiHWr/pevRPevL
	4BlaxVxkAHOWaSVd0ZlsQ==
Date: Sat, 27 Mar 2010 19:46:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anfei Zhou <anfei.zhou@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
In-Reply-To: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
Message-ID: <alpine.DEB.2.00.1003271946090.9116@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Anfei Zhou wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 9b223af..aab9892 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -381,6 +381,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>   */
>  static void __oom_kill_task(struct task_struct *p, int verbose)
>  {
> +	struct task_struct *t;
> +
>  	if (is_global_init(p)) {
>  		WARN_ON(1);
>  		printk(KERN_WARNING "tried to kill init!\n");
> @@ -412,6 +414,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  	 */
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
> +	for (t = next_thread(p); t != p; t = next_thread(t))
> +		set_tsk_thread_flag(t, TIF_MEMDIE);
>  
>  	force_sig(SIGKILL, p);
>  }

I like the concept, but I agree that it would probably be better to write 
it as Oleg suggested.  The oom killer has been rewritten in the -mm tree 
and so this patch doesn't apply cleanly, would it be possible to rebase to 
mmotm with the suggested coding sytle and post this again?

See http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt	

Thanks!
