Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2K1PYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:24:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab2K1PYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:24:12 -0500
Date: Wed, 28 Nov 2012 16:23:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v3 04/19] perf, core: Add a concept of a weightened sample
Message-ID: <20121128152327.GD1038@krava.brq.redhat.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
 <1353502185-26521-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353502185-26521-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 01:49:30PM +0100, Stephane Eranian wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

> index 4f63c05..c52caab 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -132,8 +132,10 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
>  	PERF_SAMPLE_REGS_USER			= 1U << 12,
>  	PERF_SAMPLE_STACK_USER			= 1U << 13,
> +	PERF_SAMPLE_WEIGHT			= 1U << 14,
> +
> +	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
>  
> -	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
>  };
>  
>  /*
> @@ -198,8 +200,9 @@ enum perf_event_read_format {
>  	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
>  	PERF_FORMAT_ID				= 1U << 2,
>  	PERF_FORMAT_GROUP			= 1U << 3,
> +	PERF_FORMAT_WEIGHT			= 1U << 4,

what's PERF_FORMAT_WEIGHT for?

thanks,
jirka
