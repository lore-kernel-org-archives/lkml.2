Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3ABP56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:57:58 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:28889 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab3ABP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:57:56 -0500
Date: Wed, 2 Jan 2013 15:57:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Hugh Dickins <hughd@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting
 memory
In-Reply-To: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
Message-ID: <0000013bfbfbb293-ccc455ed-2db6-46e2-8362-dc418bae0def-000000@email.amazonses.com>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013, Hugh Dickins wrote:

> @@ -2756,13 +2747,13 @@ out:
>   * @buffer:  to contain formatted mempolicy string
>   * @maxlen:  length of @buffer
>   * @pol:  pointer to mempolicy to be formatted
> - * @no_context:  "context free" mempolicy - use nodemask in w.user_nodemask
> + * @unused:  redundant argument, to be removed later.
>   *
>   * Convert a mempolicy into a string.
>   * Returns the number of characters in buffer (if positive)
>   * or an error (negative)
>   */
> -int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
> +int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int unused)
>  {
>  	char *p = buffer;
>  	int l;
> @@ -2796,10 +2787,7 @@ int mpol_to_str(char *buffer, int maxlen
>  	case MPOL_BIND:
>  		/* Fall through */
>  	case MPOL_INTERLEAVE:
> -		if (no_context)
> -			nodes = pol->w.user_nodemask;
> -		else
> -			nodes = pol->v.nodes;
> +		nodes = pol->v.nodes;
>  		break;
>

no_context was always true. Why is the code from the false branch kept?
