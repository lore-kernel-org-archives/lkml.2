Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0EUOGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:06:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0EUOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ETp/P5zPIHF3J2DWNP2DRifEwWd0Mgn9qksiawrN6L4a3/Y40EVTJicFF0ZeDN5K3d
         /bBhCIP/yQ50/Rj7qtJJG4d+gxb9/gggmx8f9ChRb0eqgzR3RdTGoD/xtx67IyxUIDQh
         hcbytBSz5ar2kMWL9yFeK/qbSw3lZwHHeelGE=
Date: Fri, 21 May 2010 16:06:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/4] perf: Support for irq exclusion
Message-ID: <20100521140623.GK30108@nowhere>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com> <1274450715-23955-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274450715-23955-4-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:05:14PM +0200, Frederic Weisbecker wrote:
> Provide exclude_softirq and exclude_hardirq support in perf
> event attributes. This brings the final pieces to subscribe
> to any desired context granularity of profiling or tracing.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  include/linux/perf_event.h |    8 +++++---
>  kernel/perf_event.c        |   42 +++++++++++++++++++++++++++++++-----------
>  2 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d939fc7..ca55ec5 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -213,10 +213,12 @@ struct perf_event_attr {
>  				 *
>  				 *  See also PERF_RECORD_MISC_EXACT_IP
>  				 */
> -				precise_ip     :  2, /* skid constraint       */
> -				exclude_task   :  1, /* don't count task context */
> +				precise_ip	:  2, /* skid constraint */
> +				exclude_task	:  1, /* don't count task context */
> +				exclude_softirq	:  1, /* don't count softirq */
> +				exclude_hardirq	:  1, /* don't count hardirq */
>  
> -				__reserved_1   : 46;
> +				__reserved_1	: 45;


Should be 44.

