Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3ABOE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ABOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:04:25 -0500
Date: Wed, 2 Jan 2013 15:04:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v4 01/18] perf, x86: Support CPU specific sysfs events
Message-ID: <20130102140405.GA931@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356018108-6081-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:41:31PM +0100, Stephane Eranian wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a way for the CPU initialization code to register additional events,
> and merge them into the events attribute directory. Used in the next
> patch.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event.h |    1 +
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 4428fd1..83f4c1a 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1341,6 +1341,30 @@ static void __init filter_events(struct attribute **attrs)
>  	}
>  }
>  
> +/* Merge two pointer arrays */
> +static __init struct attribute **merge_attr(struct attribute **a,
> +					    struct attribute **b)
> +{
> +	struct attribute **new;
> +	int j, i;
> +
> +	for (j = 0; a[j]; j++)
> +		;
> +	for (i = 0; b[i]; i++)
> +		j++;
> +	j++;
> +	new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
> +	if (!new)
> +		return a;

not likely to happen, but still.. do we want proper error handling?

other than that the patch looks ok to me

jirka
