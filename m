Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab1FQNct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:32:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1FQNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OaNQn8COqiXCNS/WHzbqy9Jv8tPSlm2QWmsDY82O/ZqR59z5kH5cmapzzooWc5OIps
         WbtGVSRtYZ1bC5Wx98jdOEYpJGcrcJWiKf9VdwseKCB4wb4cxoux3VO5N1UKqh/1edqZ
         6seU5/hIpVMwk5yVUTw10Po0fuieDNhtkDedI=
Date: Fri, 17 Jun 2011 15:32:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
Message-ID: <20110617133230.GC25197@somewhere.redhat.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
 <1307490946-24673-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307490946-24673-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:55:46PM -0600, David Ahern wrote:
> For initial perf_clock to time-of-day correlation.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/event.c   |    1 +
>  tools/perf/util/event.h   |    8 ++++++++
>  tools/perf/util/session.c |    4 ++++
>  tools/perf/util/session.h |    3 ++-
>  4 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 3c1b8a6..1a89a04 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -24,6 +24,7 @@ static const char *perf_event__names[] = {
>  	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
>  	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
>  	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
> +	[PERF_RECORD_REFTIME]			= "REF_TIME",
>  };
>  
>  const char *perf_event__name(unsigned int id)
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 1d7f664..f481f90 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -98,6 +98,7 @@ enum perf_user_event_type { /* above any possible kernel type */
>  	PERF_RECORD_HEADER_TRACING_DATA		= 66,
>  	PERF_RECORD_HEADER_BUILD_ID		= 67,
>  	PERF_RECORD_FINISHED_ROUND		= 68,
> +	PERF_RECORD_REFTIME			= 69,

We would like to avoid adding more custom events like these. They were very convenient
but they steal the kernel event type space. They are deemed for removal in the long term.

Another idea to achieve what you want would be to create a new perf event header feature,
like HEADER_TRACE_INFO or HEADER_BUILD_ID are. Then use that to create a space in the perf
file to save that couple of clocks initial values.
