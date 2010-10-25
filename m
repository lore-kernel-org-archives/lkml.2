Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0JYKPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:15:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:55316 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0JYKPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:15:51 -0400
Date: Mon, 25 Oct 2010 21:15:29 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] MIPS: MT: Fix build error iFPU affinity code
In-Reply-To: <20101024212350.GA18747@linux-mips.org>
Message-ID: <alpine.LRH.2.00.1010252115020.28519@tundra.namei.org>
References: <20101024212350.GA18747@linux-mips.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010, Ralf Baechle wrote:

> > commit b0ae19811375031ae3b3fecc65b702a9c6e5cc28
> > Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date:   Fri Oct 15 04:21:18 2010 +0900
> >
> >     security: remove unused parameter from security_task_setscheduler()
> 
> broke the build of arch/mips/kernel/mips-mt-fpaff.c.  The function
> arguments were unnecessary, not the semicolon ...
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
>  arch/mips/kernel/mips-mt-fpaff.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: James Morris <jmorris@namei.org>


> 
> diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
> index 9a526ba..802e616 100644
> --- a/arch/mips/kernel/mips-mt-fpaff.c
> +++ b/arch/mips/kernel/mips-mt-fpaff.c
> @@ -103,7 +103,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
>  	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
>  		goto out_unlock;
>  
> -	retval = security_task_setscheduler(p)
> +	retval = security_task_setscheduler(p);
>  	if (retval)
>  		goto out_unlock;
>  
> 

-- 
James Morris
<jmorris@namei.org>
