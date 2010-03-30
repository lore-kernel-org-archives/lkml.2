Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0C3StW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:49:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63469 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0C3StT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wrnroGPfgHhNjaRfKRSdvb9Baj78a7EMdHIWfMzyl7kjGMNpkxgGvQIi8SuuhVZk4m
         ZKfv1tMABiNsgnwWTnIPAWUmSBnbhQFEZ6OO2XL8J5vdv52KzYENPJY4YcGQUgVu4hUm
         QrVzbJSi4GmrsCf/bZVwogO8cNFLQMxS1teuk=
Date: Tue, 30 Mar 2010 20:49:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org
Subject: Re: [PATCH] x86,kgdb: Always initialize the hw breakpoint attribute
Message-ID: <20100330184921.GE5078@nowhere>
References: <1269974370-24831-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269974370-24831-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 01:39:30PM -0500, Jason Wessel wrote:
> It is required to call hw_breakpoint_init() on an attr before using it
> in any other calls.  This fixes the problem where kgdb will sometimes
> fail to initialize on x86_64.
> 
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: stable@kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/x86/kernel/kgdb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index bfba601..d9adcde 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -618,6 +618,7 @@ int kgdb_arch_init(void)
>  	 * portion of kgdb because this operation requires mutexs to
>  	 * complete.
>  	 */
> +	hw_breakpoint_init(&attr);
>  	attr.bp_addr = (unsigned long)kgdb_arch_init;
>  	attr.type = PERF_TYPE_BREAKPOINT;


Minor neat: In this case you don't need to set the type.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



>  	attr.bp_len = HW_BREAKPOINT_LEN_1;
> -- 
> 1.6.3.1.9.g95405b
> 

