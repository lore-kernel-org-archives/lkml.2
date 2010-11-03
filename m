Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0KCXrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:47:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0KCXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=loQ5Sf2bjh+a3GX0tRwQXDeV5K1e2pyccUiyWfZ6REh+RYU7k20UWQ8IGA94hrpm/t
         HI1969TUH3aEBNY0QOiQ==
Date: Wed, 3 Nov 2010 16:47:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <1288827804.2725.0.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011031646110.7830@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1288827804.2725.0.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Figo.zhang wrote:

> CAP_SYS_RESOURCE also had better get 3% bonus for protection.
> 

Would you like to elaborate as to why?

> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
> mm/oom_kill.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4029583..30b24b9 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -198,7 +198,8 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  	 * Root processes get 3% bonus, just like the __vm_enough_memory()
>  	 * implementation used by LSMs.
>  	 */
> -	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
>  		points -= 30;
>  
>  	/*
