Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab1GAPqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:46:09 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:57063 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1GAPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:46:06 -0400
Date: Fri, 1 Jul 2011 11:42:32 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf_event: Return -EINVAL for Offcore Response
 Events
In-Reply-To: <tip-04bffb83d17c1b93578564f18e02b6cb1c385b40@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1107011139260.31749@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu> <tip-04bffb83d17c1b93578564f18e02b6cb1c385b40@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Jul 2011, tip-bot for Vince Weaver wrote:

> Commit-ID:  04bffb83d17c1b93578564f18e02b6cb1c385b40
> Gitweb:     http://git.kernel.org/tip/04bffb83d17c1b93578564f18e02b6cb1c385b40
> Author:     Vince Weaver <vweaver1@eecs.utk.edu>
> AuthorDate: Fri, 10 Jun 2011 16:07:52 -0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 1 Jul 2011 10:27:09 +0200
> 
> perf_event: Return -EINVAL for Offcore Response Events


Wait!  Please don't apply this one.

It does indeed Return -EINVAL for Offcore Response Events but also
for *all* RAW events.

I missed that on initial testing, and then I caught the problem but 
couldn't find a simple way to return EINVAL only for config1 being set to 
nonzero.

The code used to shutdown OFFCORE_RESPONSE here is very subtle 
and non-obvious.

Vince


> 
> Return a proper error code when denying raw access to Offcore Response
> events. Right now we return "0" which gives tools the false impression
> that opening the event worked.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: <stable@kernel.org>
> Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 3a0338b..c6bfa6b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -598,7 +598,7 @@ static int x86_setup_perfctr(struct perf_event *event)
>  	 * there's no sane user-space generalization yet:
>  	 */
>  	if (attr->type == PERF_TYPE_RAW)
> -		return 0;
> +		return -EINVAL;
>  
>  	if (attr->type == PERF_TYPE_HW_CACHE)
>  		return set_ext_hw_attr(hwc, event);
> 
> 

Vince
vweaver1@eecs.utk.edu
