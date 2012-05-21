Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2EUJGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:06:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52569 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2EUJGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:06:44 -0400
Date: Mon, 21 May 2012 11:06:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120521090638.GE31407@gmail.com>
References: <1337527148.6093.14.camel@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337527148.6093.14.camel@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> Pls., consider applying this patch series.
> It contains the following changes:
>  - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
>    DECLARE_EARLY_PER_CPU_READ_MOSTLY().
>  - Adds "read-mostly" qualifier to the following variables in smp.h:
>   - cpu_sibling_map
>   - cpu_core_map
>   - cpu_llc_shared_map
>   - cpu_llc_id
>   - cpu_number
>   - x86_cpu_to_apicid
>   - x86_bios_cpu_apicid
>   - x86_cpu_to_logical_apicid
> 
> As long as all the variables above are only written during the 
> initialization, this change is meant to prevent the false 
> sharing and improve the performance on large multiprocessor 
> systems.

Mind explaining why it helps performance? Are these percpu 
variables also accessed from other CPUs, increasing the cost of 
false sharing of cache-lines?

Or is the problem that the 'cache line' size is 4096 bytes on 
vSMP, making even singular cache misses expensive and you'd like 
to move these next to each other?

So it would be nice to see some before/after PMU stats 
demonstrating the improvement. (perf works on vSMP, right?)

Thanks,

	Ingo
