Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1EJVy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:54:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1EJVyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:54:55 -0400
Date: Tue, 10 May 2011 14:54:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: tracing: Add missing GFP flags to tracing
Message-Id: <20110510145446.1f8e77e3.akpm@linux-foundation.org>
In-Reply-To: <20110510100954.GC4146@suse.de>
References: <20110510100954.GC4146@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011 11:09:54 +0100
Mel Gorman <mgorman@suse.de> wrote:

> include/linux/gfp.h and include/trace/events/gfpflags.h is out of
> sync. When tracing is enabled, certain flags are not recognised and
> the text output is less useful as a result.  Add the missing flags.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/trace/events/gfpflags.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/gfpflags.h b/include/trace/events/gfpflags.h
> index e3615c0..9fe3a366 100644
> --- a/include/trace/events/gfpflags.h
> +++ b/include/trace/events/gfpflags.h
> @@ -10,6 +10,7 @@
>   */
>  #define show_gfp_flags(flags)						\
>  	(flags) ? __print_flags(flags, "|",				\
> +	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
>  	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
>  	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
>  	{(unsigned long)GFP_USER,		"GFP_USER"},		\
> @@ -32,6 +33,9 @@
>  	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
>  	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
>  	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
> -	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
> +	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
> +	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
> +	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
> +	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
>  	) : "GFP_NOWAIT"

The patch seems somewhat needed in 2.6.38.x, but 2.6.38 doesn't have
__GFP_OTHER_NODE.  So if you think this needs fixing in -stable, please
prepare a separate patch for that.

