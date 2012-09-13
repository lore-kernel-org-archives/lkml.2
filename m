Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2IMJsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:48:39 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:56950
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab2IMJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:48:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAA8KQ-02-0RK-02
X-M-MSG: 
Date: Thu, 13 Sep 2012 11:48:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, <mingo@kernel.org>,
        <hpa@zytor.com>, <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, <namhyung.kim@lge.com>, <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [PATCH] perf record: Add missing perf_hpp__init for pipe-mode
Message-ID: <20120913094826.GD8285@erda.amd.com>
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
 <tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
 <20120912172641.GB29278@erda.amd.com>
 <20120912184815.GC557@infradead.org>
 <87y5ke8wxv.fsf@sejong.aot.lge.com>
 <87txv28spl.fsf_-_@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87txv28spl.fsf_-_@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.12 13:14:30, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The perf_hpp__init() function was only called from setup_browser() so
> that the pipe-mode missed the initialization thus didn't respond to
> related options.  Fix it.
> 
> Reported-by: Robert Richter <robert.richter@amd.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

This patch fixes it.

Thanks,

-Robert

> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 97b2e6300f4c..279155a47d1c 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -689,8 +689,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	if (strcmp(report.input_name, "-") != 0)
>  		setup_browser(true);
> -	else
> +	else {
>  		use_browser = 0;
> +		perf_hpp__init(false, false);
> +	}
>  
>  	/*
>  	 * Only in the newt browser we are doing integrated annotation,
> -- 
> 1.7.11.4
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

