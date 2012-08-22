Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2HVST1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab2HVSTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:19:23 -0400
Date: Wed, 22 Aug 2012 15:18:34 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@kernel.org, eranian@google.com,
        gorcunov@openvz.org, benjamin.redelings@nescent.org,
        fweisbec@gmail.com, robert.richter@amd.com, drepper@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, asharma@fb.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com,
        mingo@elte.hu
Subject: Re: [PATCH] perf: Keep the perf_event_attr on version 3
Message-ID: <20120822181834.GG7764@infradead.org>
References: <1344345647-11536-6-git-send-email-jolsa@redhat.com>
 <tip-c5ebcedb566ef17bda7b02686e0d658a7bb42ee7@git.kernel.org>
 <1345569116.26596.4.camel@twins>
 <20120822083540.GB1003@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822083540.GB1003@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 22, 2012 at 10:35:40AM +0200, Jiri Olsa escreveu:
> On Tue, Aug 21, 2012 at 07:11:56PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-08-21 at 08:49 -0700, tip-bot for Jiri Olsa wrote:
> > >  #define PERF_ATTR_SIZE_VER3    88      /* add: sample_regs_user */
> > > +#define PERF_ATTR_SIZE_VER4    96      /* add: sample_stack_user */
> > 
> > Both are introduced in this patch set, there's no release in between,
> > why are we doing two version increments? Seems like pointless version
> > space inflation to me.
> 
> not sure why I did that, attached patch returns that to version3

I'm lazy so couldn't quickly find any problem in applying this patch,
Peter, can you see any problem?

Will add your Acked-by if you can't.

- Arnaldo
 
> jirka
> 
> ---
> Stashing version 4 under version 3 and removing version 4,
> because both version changes were within single patchset.
> 
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h | 4 ++--
>  tools/perf/util/header.c   | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 297ca3d..28f9cee 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -205,8 +205,8 @@ enum perf_event_read_format {
>  #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
>  #define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
>  #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
> -#define PERF_ATTR_SIZE_VER3	88	/* add: sample_regs_user */
> -#define PERF_ATTR_SIZE_VER4	96	/* add: sample_stack_user */
> +#define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
> +					/* add: sample_stack_user */
>  
>  /*
>   * Hardware event_id to monitor via a performance monitoring event:
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 1e5b6aa..5ed4812 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1831,7 +1831,6 @@ static const int attr_file_abi_sizes[] = {
>  	[1] = PERF_ATTR_SIZE_VER1,
>  	[2] = PERF_ATTR_SIZE_VER2,
>  	[3] = PERF_ATTR_SIZE_VER3,
> -	[4] = PERF_ATTR_SIZE_VER4,
>  	0,
>  };
>  
> -- 
> 1.7.11.4
