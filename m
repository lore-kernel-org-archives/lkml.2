Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0CRRgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:36:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0CRRgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:36:37 -0400
Date: Thu, 18 Mar 2010 18:36:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix stat attach bogus counts
Message-ID: <20100318173615.GA2456@elte.hu>
References: <4ba0e3c7.1c185e0a.7786.ffffb1d9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba0e3c7.1c185e0a.7786.ffffb1d9@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> 	When perf stat -p pid is used, the events must be enabled
> 	immediately as there is no exec and thus no enable_on_exec.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> --
>  builtin-stat.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 95db31c..3a91fad 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -159,8 +159,10 @@ static void create_perf_stat_counter(int counter, int pid)
>  		}
>  	} else {
>  		attr->inherit	     = inherit;
> -		attr->disabled	     = 1;
> -		attr->enable_on_exec = 1;
> +		if (target_pid == -1) {
> +			attr->disabled	     = 1;
> +			attr->enable_on_exec = 1;
> +		}

Mind checking latest -tip, which has these commits:

d6d901c: perf events: Change perf parameter --pid to process-wide collection instead of thread-wid
46be604: perf record: Enable counters only when kernel is execing subcommand
6be2850: perf stat: Enable counters when collecting process-wide or system-wide data

as they fix/improve various --pid related behavioral aspects of perf. Does it 
work fine for you now?

	Ingo
