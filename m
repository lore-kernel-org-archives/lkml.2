Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1BWAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:16:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab1BWAQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:16:58 -0500
From: Thomas Renninger <trenn@suse.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [15/70] perf timechart: Adjust perf timechart to the new power events
Date: Wed, 23 Feb 2011 01:17:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, Ingo Molnar <mingo@elte.hu>
References: <20110222221838.567882669@clark.kroah.org>
In-Reply-To: <20110222221838.567882669@clark.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201102230117.20631.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I should have split out this segfault fix.

On Tuesday 22 February 2011 23:16:54 Greg KH wrote:
> 2.6.37-stable review patch.  If anyone has any objections, please let
> us know.
> 
> ------------------
> 
> From: Thomas Renninger <trenn@suse.de>
> 
> commit 20c457b8587bee4644d998331d9e13be82e05b4c upstream.
> 
> [This patch is part of mainline git commit 20c457b8587bee4644d9.
>   This should fix:
>   http://www.mail-archive.com/linux-perf-
>   users@vger.kernel.org/msg00057.html
> 
>   The regression was introduced by git commit:
>   4c21adf26f8fcf86a755b9b9f55c2e9fd241e1fb]
Above link is a nice pointer.
the rest of the changelog (below) does not fit and describes
the mainline patch, the tiny fix was part of.

Don't know whether it's worth to touch it, but if, the changelog (or 
title) of the patch should be as short as:
perf: timechart (userspace): Do not segfault on power_end events

         Thomas

> builtin-timechart must only pass -e power:xy events if they are 
supported by
> the running kernel, otherwise try to fetch the old 
power:power{start,end}
> events.
> 
> For this I added the tiny helper function:
> 
>    int is_valid_tracepoint(const char *event_string)
> 
> to parse-events.[hc], which could be more generic as an interface and 
support
> hardware/software/... events, not only tracepoints, but someone else 
could
> extend that if needed...
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Jean Pihet <j-pihet@ti.com>
> LKML-Reference: <1294073445-14812-4-git-send-email-trenn@suse.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  tools/perf/builtin-timechart.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -502,7 +502,7 @@ static int process_sample_event(event_t
>  			c_state_start(pe->cpu_id, data.time, pe->value);
>  
>  		if (strcmp(event_str, "power:power_end") == 0)
> -			c_state_end(pe->cpu_id, data.time);
> +			c_state_end(data.cpu, data.time);
>  
>  		if (strcmp(event_str, "power:power_frequency") == 0)
>  			p_state_change(pe->cpu_id, data.time, pe->value);
> 
> 
> 

