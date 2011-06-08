Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1FHDpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:45:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51144 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1FHDpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:45:35 -0400
X-AuditID: b753bd60-a1479ba0000050a4-e0-4deef05d419e
X-AuditID: b753bd60-a1479ba0000050a4-e0-4deef05d419e
Message-ID: <4DEEF05A.3010007@hitachi.com>
Date: Wed, 08 Jun 2011 12:45:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 2/3 v2] kprobes/trace: Fix kprobe selftest for gcc 4.6
References: <20110607212937.662660421@goodmis.org> <20110607213007.312394187@goodmis.org>
In-Reply-To: <20110607213007.312394187@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 6:29), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> With gcc 4.6, the self test kprobe function:
> 
>  kprobe_trace_selftest_target()
> 
> is optimized such that kallsyms does not list it. The kprobes
> test uses this function to insert a probe and test it. But
> it will fail the test if the function is not listed in kallsyms.
> 
> Adding a __used annotation keeps the symbol in the kallsyms table.

Thanks Steven and David,

That's good to me!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Suggested-by: David Daney <ddaney@caviumnetworks.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index f925c45..27d13b3 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1870,8 +1870,12 @@ fs_initcall(init_kprobe_trace);
>  
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>  
> -static int kprobe_trace_selftest_target(int a1, int a2, int a3,
> -					int a4, int a5, int a6)
> +/*
> + * The "__used" keeps gcc from removing the function symbol
> + * from the kallsyms table.
> + */
> +static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
> +					       int a4, int a5, int a6)
>  {
>  	return a1 + a2 + a3 + a4 + a5 + a6;
>  }


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
