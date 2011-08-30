Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1H3NOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 09:14:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59866 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1H3NON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:14:13 -0400
Subject: Re: [PATCH] x86, perf: check that current->mm alive before getting
 user callchain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 30 Aug 2011 15:14:03 +0200
In-Reply-To: <1314693156-24131-1-git-send-email-avagin@openvz.org>
References: <1314693156-24131-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314710043.5812.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 12:32 +0400, Andrey Vagin wrote:
> An event may occurs when mm is already released.

> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 4ee3abf..cfa62ec 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1900,6 +1900,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
>  
>  	perf_callchain_store(entry, regs->ip);
>  
> +	if (!current->mm)
> +		return;
> +
>  	if (perf_callchain_user32(regs, entry))
>  		return;
>  

Thanks!
