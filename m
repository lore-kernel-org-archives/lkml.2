Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1ASBaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:30:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36635 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1ASBaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:30:00 -0500
X-AuditID: b753bd60-9f090ba000000ca4-e6-4d363e946d37
Message-ID: <4D363E92.2020602@hitachi.com>
Date: Wed, 19 Jan 2011 10:29:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Switch proc interfaces in kernel/ to %pK
References: <1295391078.1831.21.camel@dan>
In-Reply-To: <1295391078.1831.21.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/19 7:51), Dan Rosenberg wrote:
> Switch users of %p in /proc interfaces in kernel/ to %pK, to allow
> configuring the level of exposure of kernel pointers via the
> kptr_restrict sysctl.

This report_probe interface is at /sys/kernel/debug/kprobes/list.
Is that policy applied to debugfs interface (for debug) too?
# in that case, you might update ftrace and perf tracing interfaces...

> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 7798181..2437ca4 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2021,11 +2021,11 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
>  		kprobe_type = "k";
>  
>  	if (sym)
> -		seq_printf(pi, "%p  %s  %s+0x%x  %s ",
> +		seq_printf(pi, "%pK  %s  %s+0x%x  %s ",
>  			p->addr, kprobe_type, sym, offset,
>  			(modname ? modname : " "));
>  	else
> -		seq_printf(pi, "%p  %s  %p ",
> +		seq_printf(pi, "%pK  %s  %pK ",
>  			p->addr, kprobe_type, p->addr);
>  
>  	if (!pp)


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
