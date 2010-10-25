Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0JYAkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:40:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38321 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0JYAkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:40:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: MT: Fix build error iFPU affinity code
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        James Morris <jmorris@namei.org>
In-Reply-To: <20101024212350.GA18747@linux-mips.org>
References: <20101024212350.GA18747@linux-mips.org>
Message-Id: <20101025093921.9151.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Oct 2010 09:40:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Agh! Thank you for fixing this!


