Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769Ab0J2Ttx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:49:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:35583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0J2Ttv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:49:51 -0400
Subject: Re: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, "Ma Ling:" <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Oct 2010 21:49:11 +0200
Message-ID: <1288381751.1988.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 01:01 +0900, Hitoshi Mitake wrote:
> This patch ports arch/x86/lib/memcpy_64.S to "perf bench mem".
> When PERF_BENCH is defined at preprocessor level,
> memcpy_64.S is preprocessed to includable form from the sources
> under tools/perf for benchmarking programs.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Ma Ling: <ling.ma@intel.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/lib/memcpy_64.S |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index 75ef61e..72c6dfe 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -1,10 +1,23 @@
>  /* Copyright 2002 Andi Kleen */
>  
> +/*
> + * perf bench adoption by Hitoshi Mitake
> + * PERF_BENCH means that this file is included from
> + * the source files under tools/perf/ for benchmark programs.
> + *
> + * You don't have to care about PERF_BENCH when
> + * you are working on the kernel.
> + */
> +
> +#ifndef PERF_BENCH

I don't like littering the actual kernel code with tools/perf/
ifdeffery..
