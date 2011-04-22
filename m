Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab1DVGer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 02:34:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1DVGeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 02:34:46 -0400
Date: Fri, 22 Apr 2011 08:34:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110422063429.GA16643@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303407662-15564-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> The offcore_msr perf kernel code was merged into 2.6.39-rc*, but the
> user space bits were not. This made it impossible to set the extra mask
> and actually do the OFFCORE profiling
> 
> This patch fixes this. It adds a new syntax ':' to raw events to specify
> additional event masks. I also added support for setting config2, even
> though that is not needed currently.
> 
> [Note: the original version back in time used , -- but that actually
> conflicted with event lists, so now it's :]
> 
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@gmail.com>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Link: http://lkml.kernel.org/r/1302658203-4239-1-git-send-email-andi@firstfloor.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Documentation/perf-list.txt |   11 +++++++++++
>  tools/perf/util/parse-events.c         |   18 +++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
> index 7a527f7..f19f1e5 100644
> --- a/tools/perf/Documentation/perf-list.txt
> +++ b/tools/perf/Documentation/perf-list.txt
> @@ -61,6 +61,17 @@ raw encoding of 0x1A8 can be used:
>  You should refer to the processor specific documentation for getting these
>  details. Some of them are referenced in the SEE ALSO section below.
>  
> +Some raw events -- like the Intel OFFCORE events -- support additional
> +parameters. These can be appended after a ':'.
> +
> +For example on a multi socket Intel Nehalem:
> +
> + perf stat -e r1b7:20ff -a sleep 1
> +
> +Profile the OFFCORE_RESPONSE.ANY_REQUEST with event mask REMOTE_DRAM_0
> +that measures any access to DRAM on another socket.  Upto two parameters can
> +be specified with additional ':'

This needs to be a *lot* more user friendly. Users do not want to type in 
stupid hexa magic numbers to get profiling. We have moved beyond the oprofile 
era really.

Unless there's proper generalized and human usable support i'm leaning towards 
turning off the offcore user-space accessible raw bits for now, and use them 
only kernel-internally, for the cache events.

Thanks,

	Ingo
