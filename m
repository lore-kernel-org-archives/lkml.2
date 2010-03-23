Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0CWBIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:08:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0CWBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=elSHKUmxprZ9x2Hy1BwYbwSr1WmQ58QXt+5eMsa7nOmUaWe6Rz8eS2i4J6l7aR85wo
         FHrtup37jzgPa66Bkc1ypKYfC9H5TW07a5D1oJyUPmPJQwIs7zCySvRP+Rjnoa1tVY7p
         iDStA5Ah/2kRgMH/rTvfP2VW0Mehrq1ZQnQKU=
Date: Tue, 23 Mar 2010 02:07:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/18] sched: Generate trace points only if scheduler
	tracing is enabled
Message-ID: <20100323010756.GB8292@nowhere>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <1269304340-25372-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269304340-25372-7-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 01:32:08AM +0100, Jan Kara wrote:
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---


Note this one is an exception.
Once tracing is enabled, we need the context switch
tracer anyway to keep track of the pid:cmdline mappings.



>  include/trace/events/sched.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index cfceb0b..0a08ab1 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -1,5 +1,7 @@
>  #undef TRACE_SYSTEM
> +#undef TRACE_CONFIG
>  #define TRACE_SYSTEM sched
> +#define TRACE_CONFIG CONFIG_CONTEXT_SWITCH_TRACER
>  
>  #if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_SCHED_H
> -- 
> 1.6.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

