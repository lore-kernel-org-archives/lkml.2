Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2IKJV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:21:57 -0400
Received: from [216.32.180.185] ([216.32.180.185]:49542 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab2IKJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:21:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202h1d1ahzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MA6HYE-02-6TA-02
X-M-MSG: 
Date: Tue, 11 Sep 2012 11:20:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
Message-ID: <20120911092026.GU8285@erda.amd.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
 <1347295216-1202-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347295216-1202-4-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.12 10:40:16, David Ahern wrote:
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -294,6 +294,11 @@ try_again:
>  					  perf_evsel__name(pos));
>  				rc = -err;
>  				goto out;
> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {

It is EOPNOTSUPP, did you test this?

> +				ui__error("\'precise\' request not supported. "
> +					  "Try removing 'p' modifier\n");

I would better print "... request may not be supported.", since you
don't know for sure if this is the real cause.

> +				rc = -err;
> +				goto out;
>  			}
>  
>  			printf("\n");
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 0513aaa..0d3653b 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -975,6 +975,10 @@ try_again:
>  				ui__error("Too many events are opened.\n"
>  					    "Try again after reducing the number of events\n");
>  				goto out_err;
> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
> +				ui__error("\'precise\' request not supported. "
> +					  "Try removing 'p' modifier\n");

Same here.

> +				goto out_err;

To avoid adding more duplicate code, maybe we should start to unify
the code by implementing this in a shared helper function.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

