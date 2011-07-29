Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1G2Xi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:38:29 -0400
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:17750 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1G2Xi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:38:28 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jul 2011 19:38:28 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAI9BM06rRDoJ/2dsb2JhbAA0AQEBAQMUAW8BEQwUBAkiDwkDAgECAQJRBwENAQgGAQEfp1J3qnqeOoZCBIdaiyCFB4t8
X-IronPort-AV: E=Sophos;i="4.67,289,1309737600"; 
   d="scan'208";a="7950150"
Message-ID: <4E334235.8070304@cisco.com>
Date: Fri, 29 Jul 2011 17:28:53 -0600
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, acme@redhat.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [PATCH] perf: add --symfs option to perf annotate
References: <20110729232040.GA21838@quad>
In-Reply-To: <20110729232040.GA21838@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 05:20 PM, Stephane Eranian wrote:
> 
> If you have --symfs in perf report, then you also need it
> for perf annotate. This allows off-box assembly level analysis
> of perf.data samples.
> 
> This patch complements:
> 
> commit ec5761eab318e50e69fcf8e63e9edaef5949c067
> Author: David Ahern <daahern@cisco.com>
> Date:   Thu Dec 9 13:27:07 2010 -0700
> 
>     perf symbols: Add symfs option for off-box analysis using specified tree
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
> index 85c5f02..15919dd 100644
> --- a/tools/perf/Documentation/perf-annotate.txt
> +++ b/tools/perf/Documentation/perf-annotate.txt
> @@ -72,6 +72,9 @@ OPTIONS
>  	CPUs are specified with -: 0-2. Default is to report samples on all
>  	CPUs.
>  
> +--symfs=<directory>::
> +        Look for files with symbols relative to this directory.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-report[1]
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 555aefd..1605fbe 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -267,6 +267,8 @@ static const struct option options[] = {
>  	OPT_BOOLEAN('P', "full-paths", &full_paths,
>  		    "Don't shorten the displayed pathnames"),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
> +	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
> +		    "Look for files with symbols relative to this directory"),
>  	OPT_END()
>  };
>  

Acked-by: David Ahern <daahern@cisco.com>

Nice to see others making use of that option.

David
