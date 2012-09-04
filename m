Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab2IDXLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:11:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2IDXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:11:04 -0400
Date: Tue, 4 Sep 2012 16:11:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        rusty@rustcorp.com.au, bhelgaas@google.com,
        David Rientjes <rientjes@google.c>
Subject: Re: [PATCH 2/2] numa: don't check if node is NUMA_NO_NODE
Message-Id: <20120904161102.143ceb6d.akpm@linux-foundation.org>
In-Reply-To: <5044665C.5020909@cn.fujitsu.com>
References: <504457C8.10209@cn.fujitsu.com>
	<5044665C.5020909@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2012 16:12:12 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> If we don't debug per_cpu maps, the cpu's node is stored in per_cpu variable
> numa_node. If node is NUMA_NO_NODE, it means the caller want to clear the
> cpu's node. So we should also call set_cpu_numa_node() in this case.

The changelog is missing important information.

What is the runtime effect of the patch?  In other words, please fully
describe the runtime effects of the bug which the patch fixed.

Please always provide this information.  It will help others decide
which kernel version(s) should be patched, and will help the
maintainers of other kernel trees (especially vendor trees) to work out
whether they should backport the fix into their kernels.

> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -97,8 +97,7 @@ void __cpuinit numa_set_node(int cpu, int node)
>  #endif
>  	per_cpu(x86_cpu_to_node_map, cpu) = node;
>  
> -	if (node != NUMA_NO_NODE)
> -		set_cpu_numa_node(cpu, node);
> +	set_cpu_numa_node(cpu, node);
>  }
>  
>  void __cpuinit numa_clear_node(int cpu)

