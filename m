Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2AOCqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:46:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4049 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2AOCq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:46:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6589"; a="155116616"
Message-ID: <4F123E02.2070401@codeaurora.org>
Date: Sat, 14 Jan 2012 18:46:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + debugobjects-fix-selftest-for-static-warnings.patch added to
 -mm tree
References: <20111215213549.09360200057@hpza10.eem.corp.google.com>
In-Reply-To: <20111215213549.09360200057@hpza10.eem.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/11 13:35, akpm@linux-foundation.org wrote:
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: debugobjects: Fix selftest for static warnings
>
> debugobjects is now printing a warning when a fixup for a NOTAVAILABLE
> object is run.  This causes the selftest to fail like:
>
> [    0.000000] ODEBUG: selftest warnings failed 4 != 5
>
> We could just increase the number of warnings that the selftest is
> expecting to see because that is actually what has changed.  But, it turns
> out that fixup_activate() was written with inverted logic and thus a fixup
> for a static object returned 1 indicating the object had been fixed, and 0
> otherwise.  Fix the logic to be correct and update the counts to reflect
> that nothing needed fixing for a static object.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Reported-By: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>

Can this be picked up or merged into 3.3-rc1? Linus' tree has a broken
selftest without this change.

>  lib/debugobjects.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff -puN lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings lib/debugobjects.c
> --- a/lib/debugobjects.c~debugobjects-fix-selftest-for-static-warnings
> +++ a/lib/debugobjects.c
> @@ -818,17 +818,9 @@ static int __init fixup_activate(void *a
>  		if (obj->static_init == 1) {
>  			debug_object_init(obj, &descr_type_test);
>  			debug_object_activate(obj, &descr_type_test);
> -			/*
> -			 * Real code should return 0 here ! This is
> -			 * not a fixup of some bad behaviour. We
> -			 * merily call the debug_init function to keep
> -			 * track of the object.
> -			 */
> -			return 1;
> -		} else {
> -			/* Real code needs to emit a warning here */
> +			return 0;
>  		}
> -		return 0;
> +		return 1;
>  
>  	case ODEBUG_STATE_ACTIVE:
>  		debug_object_deactivate(obj, &descr_type_test);
> @@ -967,7 +959,7 @@ static void __init debug_objects_selftes
>  
>  	obj.static_init = 1;
>  	debug_object_activate(&obj, &descr_type_test);
> -	if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
> +	if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
>  		goto out;
>  	debug_object_init(&obj, &descr_type_test);
>  	if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))
> _

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

