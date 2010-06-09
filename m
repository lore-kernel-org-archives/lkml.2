Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0FIUmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:42:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0FIUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:42:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=A6Ec3L//iWvAEEalwzVpQyNKFFqOYL3aX218fV06nWGoXZijpVjrgtWLq9A0BV99d
	/cMdUPhxB9Hcd1ntqCDBQ==
Date: Wed, 9 Jun 2010 13:41:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
In-Reply-To: <20100609195309.GA6899@redhat.com>
Message-ID: <alpine.DEB.2.00.1006091341040.3490@chino.kir.corp.google.com>
References: <20100602185812.4B5894A549@magilla.sf.frob.com> <20100602203827.GA29244@redhat.com> <20100604194635.72D3.A69D9226@jp.fujitsu.com> <20100604112721.GA12582@redhat.com> <20100609195309.GA6899@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Oleg Nesterov wrote:

> --- x/mm/oom_kill.c
> +++ x/mm/oom_kill.c
> @@ -414,6 +414,7 @@ static void __oom_kill_task(struct task_
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
>  
> +	clear_bit(MMF_COREDUMP, &p->mm->flags);
>  	force_sig(SIGKILL, p);
>  }
>  

This requires task_lock(p).
