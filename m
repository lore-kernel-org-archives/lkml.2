Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1FJGiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:38:13 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41499 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752332Ab1FJGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:38:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Bjt2hdFCPHU/z8OYn6qPW+WILW1bzBIkvyD0AwvRfBy/BYn95iz3EQo4ezk4TpGHs+VqJKSE8XsLEsdhY/oJ1nzkNgoG2ExDhHsXKdmD55UrVahduoAZwti+518sO0aF;
Date: Thu, 9 Jun 2011 23:38:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: x86@kernel.org, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) if
 CONFIG_APM_MODULE (only)
Message-Id: <20110609233806.58361a92.rdunlap@xenotime.net>
In-Reply-To: <1307677436.22348.589.camel@localhost>
References: <1307677436.22348.589.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 04:43:56 +0100 Ben Hutchings wrote:

> Commit 06ae40ce073daf233607a3c54a489f2c1e44683e ('x86 idle:
> EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it') made
> these exports dependent on CONFIG_APM_MODULE && CONFIG_APM_CPU_IDLE.
> However, the apm module always needs these symbols.
> CONFIG_APM_CPU_IDLE only controls whether it installs its CPU idle
> handler by default.

also fixed here:  https://lkml.org/lkml/2011/6/8/170

but yes, someone please get it merged.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This fixes a regression in 3.0-rc1 and should be applied in this cycle.
> 
> Ben.
> 
>  arch/x86/kernel/process.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 2e4928d..e1ba8cb 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -337,7 +337,7 @@ EXPORT_SYMBOL(boot_option_idle_override);
>   * Powermanagement idle function, if any..
>   */
>  void (*pm_idle)(void);
> -#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
> +#ifdef CONFIG_APM_MODULE
>  EXPORT_SYMBOL(pm_idle);
>  #endif
>  
> @@ -399,7 +399,7 @@ void default_idle(void)
>  		cpu_relax();
>  	}
>  }
> -#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
> +#ifdef CONFIG_APM_MODULE
>  EXPORT_SYMBOL(default_idle);
>  #endif
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
