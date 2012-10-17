Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2JQQjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:39:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49188 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab2JQQjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:39:20 -0400
Date: Wed, 17 Oct 2012 22:10:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, oleg@redhat.com
Subject: Re: [PATCH 2/9] uprobes: check for single step support
Message-ID: <20121017164059.GF11096@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-2-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1350242593-17761-2-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101716-7182-0000-0000-000002DC7F0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rabin Vincent <rabin@rab.in> [2012-10-14 21:23:06]:

> Check for single step support before calling user_enable_single_step(),
> since user_enable_single_step() just BUG()s if support does not exist.
> Needed by ARM.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  kernel/events/uprobes.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 98256bc..db4e3ab 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1450,7 +1450,8 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
> 
>  void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
>  {
> -	user_enable_single_step(current);
> +	if (arch_has_single_step())
> +		user_enable_single_step(current);
>  }
> 
>  void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)

This change is fine. But I am wondering if should have a dummy
arch_uprobe_enable_step / arch_uprobe_disable_step in uprobes ARM.

If arch_uprobe_enable_step() wasnt a weak function, then the fix you
suggested would have been the only way to go.

Again, I am not against this change. But I am hoping that we get
feedback on which option is prefered, having this check or having a
dummy function in archs like ARM.

-- 
Thanks and Regards
Srikar

