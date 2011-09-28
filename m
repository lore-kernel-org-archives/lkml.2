Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1I1JU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:20:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38859 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab1I1JUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:20:24 -0400
X-AuditID: b753bd60-97c2cba0000070ad-84-4e82e6d5a527
X-AuditID: b753bd60-97c2cba0000070ad-84-4e82e6d5a527
Message-ID: <4E82E6D0.4000508@hitachi.com>
Date: Wed, 28 Sep 2011 18:20:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 25/26]   perf: Documentation for perf
 uprobes
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120507.25326.68120.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920120507.25326.68120.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/20 21:05), Srikar Dronamraju wrote:
> Modify perf-probe.txt to include uprobe documentation

This change should be included in 23rd and 24th patches,
because the documentation should be updated with the tool
enhancement.

Thank you,

> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  tools/perf/Documentation/perf-probe.txt |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
> index 800775e..3c98a54 100644
> --- a/tools/perf/Documentation/perf-probe.txt
> +++ b/tools/perf/Documentation/perf-probe.txt
> @@ -78,6 +78,8 @@ OPTIONS
>  -F::
>  --funcs::
>  	Show available functions in given module or kernel.
> +	With -x/--exec, can also list functions in a user space executable
> +	/ shared library.
>  
>  --filter=FILTER::
>  	(Only for --vars and --funcs) Set filter. FILTER is a combination of glob
> @@ -98,6 +100,11 @@ OPTIONS
>  --max-probes::
>  	Set the maximum number of probe points for an event. Default is 128.
>  
> +-x::
> +--exec=PATH::
> +	Specify path to the executable or shared library file for user
> +	space tracing. Can also be used with --funcs option.
> +
>  PROBE SYNTAX
>  ------------
>  Probe points are defined by following syntax.
> @@ -182,6 +189,13 @@ Delete all probes on schedule().
>  
>   ./perf probe --del='schedule*'
>  
> +Add probes at zfree() function on /bin/zsh
> +
> + ./perf probe -x /bin/zsh zfree
> +
> +Add probes at malloc() function on libc
> +
> + ./perf probe -x /lib/libc.so.6 malloc
>  
>  SEE ALSO
>  --------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
