Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2KTKn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:43:56 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48867 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTKnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:43:55 -0500
Message-ID: <50AB5EDC.20009@in.ibm.com>
Date: Tue, 20 Nov 2012 16:13:40 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf/powerpc: Use uapi/unistd.h to fix build error
References: <20121107191818.GA16211@us.ibm.com>
In-Reply-To: <20121107191818.GA16211@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112010-6102-0000-0000-00000298C477
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192924; UDB=6.00043717; UTC=2012-11-20
 10:40:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 12:48 AM, Sukadev Bhattiprolu wrote:
>
>  From b8beef080260c1625c8f801105504a82005295e5 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 31 Oct 2012 11:21:28 -0700
> Subject: [PATCH 1/4] perf/powerpc: Use uapi/unistd.h to fix build error
>
> Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Without this patch, I couldn't build perf on powerpc, with 3.7.0-rc2

Tested-by: Suzuki K. Poulose <suzuki@in.ibm.com>

Thanks
Suzuki
> ---
>   tools/perf/perf.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 054182e..f4952da 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -26,7 +26,7 @@ void get_term_dimensions(struct winsize *ws);
>   #endif
>
>   #ifdef __powerpc__
> -#include "../../arch/powerpc/include/asm/unistd.h"
> +#include "../../arch/powerpc/include/uapi/asm/unistd.h"
>   #define rmb()		asm volatile ("sync" ::: "memory")
>   #define cpu_relax()	asm volatile ("" ::: "memory");
>   #define CPUINFO_PROC	"cpu"
>

