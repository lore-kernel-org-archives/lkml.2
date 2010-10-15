Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0JOCvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:51:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab0JOCvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:51:01 -0400
Date: Fri, 15 Oct 2010 04:50:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
Subject: Re: [PATCH 2/3] ftrace/x86: Add support for C version of recordmcount
Message-ID: <20101015025047.GA9640@elte.hu>
References: <20101014210014.895157788@goodmis.org>
 <20101014210136.230687571@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014210136.230687571@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds the support for the C version of recordmcount and
> compile times show ~ 12% improvement.

I reported this recordmcount performance problem 2 years ago. Better 
later than never i guess.

> +ifdef CONFIG_DYNAMIC_FTRACE
> +	ifdef CONFIG_HAVE_C_MCOUNT_RECORD
> +		BUILD_C_RECORDMCOUNT := y
> +		export BUILD_C_RECORDMCOUNT

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -33,6 +33,7 @@ config X86
>  	select HAVE_KRETPROBES
>  	select HAVE_OPTPROBES
>  	select HAVE_FTRACE_MCOUNT_RECORD
> +	select HAVE_C_MCOUNT_RECORD

The naming is inconsistent here - it should be HAVE_C_RECORDMCOUNT, like 
the build variable has, and like the utility is called. If we are going 
to add this flag to most architectures we should name it consistently.

Thanks,

	Ingo
