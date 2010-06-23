Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0FWQzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:55:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:48283 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0FWQzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EIKQO5tMr8x/L6j2n8TrxTDthoye+jZLjME+Ld0GuyKKzihhDS0IhgQIDHqbLZFsyX
         trRyKEMBEQmP3bPXirAHTHeB1y9jNqu+O3BhxMFqQip299gxFmJMJ0QQSJpvM2V/cSdI
         UjjdeaMD2eNjoCDb2OLn4z1xkgXX/4NFEFoc8=
Date: Wed, 23 Jun 2010 18:55:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
	tree related)
Message-ID: <20100623165523.GG5242@nowhere>
References: <20100624023117.219953e4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624023117.219953e4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,


On Thu, Jun 24, 2010 at 02:31:17AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sh allnoconfig -
> in fact, all the sh configs) failed like this:
> 
> cc1: warnings being treated as errors
> In file included from include/linux/ftrace_event.h:8,
>                  from include/trace/syscall.h:6,
>                  from include/linux/syscalls.h:75,
>                  from arch/sh/kernel/sys_sh32.c:9:
> include/linux/perf_event.h:937: error: 'struct regs' declared inside parameter list
> include/linux/perf_event.h:937: error: its scope is only this definition or declaration, which is probably not what you want
> include/linux/perf_event.h: In function 'perf_fetch_caller_regs':
> include/linux/perf_event.h:952: error: passing argument 1 of 'perf_arch_fetch_caller_regs' from incompatible pointer type
> 
> This started after next-20100618.
> 
> Caused by commit b0f82b81fe6bbcf78d478071f33e44554726bc81 ("perf: Drop
> the skip argument from perf_arch_fetch_regs_caller") which contained a
> typo in the type of the first argument to perf_arch_fetch_caller_regs()
> in the case that the architecture did not define
> perf_arch_fetch_caller_regs.


There is a pending fix:

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
[PATCH] perf: Fix argument of perf_arch_fetch_caller_regs

I'm going to send a pull request to Ingo so that gets fixed soon.

Thanks.

