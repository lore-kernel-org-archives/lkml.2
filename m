Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0C3TPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:15:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42860 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0C3TPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TSEsm+raThkLi/5FfhN+unM4P5O/fiOZy3pkpo+nGAFmwjzWic8ctHZKkx86/Qa7nu
         AcKjGwjZGhlbnEgVFJyBro+CT/86brI9d6p3n0k76H3S+Kjd0BsdHM9UPeV4A6E+3qDg
         lGFBFLCvrRiC42xGilicOabwvO3/09QRRIDIQ=
Date: Tue, 30 Mar 2010 21:15:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org
Subject: Re: [PATCH 1/1] x86,kgdb: Always initialize the hw breakpoint
	attribute
Message-ID: <20100330191502.GG5078@nowhere>
References: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 02:05:07PM -0500, Jason Wessel wrote:
> It is required to call hw_breakpoint_init() on an attr before using it
> in any other calls.  This fixes the problem where kgdb will sometimes
> fail to initialize on x86_64.
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: stable@kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


Queued for perf/urgent, thanks!



> ---
>  arch/x86/kernel/kgdb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index bfba601..b2258ca 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -618,8 +618,8 @@ int kgdb_arch_init(void)
>  	 * portion of kgdb because this operation requires mutexs to
>  	 * complete.
>  	 */
> +	hw_breakpoint_init(&attr);
>  	attr.bp_addr = (unsigned long)kgdb_arch_init;
> -	attr.type = PERF_TYPE_BREAKPOINT;
>  	attr.bp_len = HW_BREAKPOINT_LEN_1;
>  	attr.bp_type = HW_BREAKPOINT_W;
>  	attr.disabled = 1;
> -- 
> 1.5.4.3
> 

