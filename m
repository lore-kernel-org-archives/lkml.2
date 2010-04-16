Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0DPWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:18:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932635Ab0DPWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:18:23 -0400
Date: Fri, 16 Apr 2010 15:18:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: benh@kernel.crashing.org, roel.kluin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvsi: Messed up error checking getting state name
Message-Id: <20100416151808.a8a5d340.akpm@linux-foundation.org>
In-Reply-To: <1271418554-21278-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1271418554-21278-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 14:49:14 +0300
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> Handle out-of-range indices before reading what they refer
> to.

Well...  That doesn't matter really - as long as we don't dereference it.

> And don't access the one-past-the-end element of the
> array either.
> 

Yup, that's a bug.

> ---
>  drivers/char/hvsi.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
> index 793b236..d4b14ff 100644
> --- a/drivers/char/hvsi.c
> +++ b/drivers/char/hvsi.c
> @@ -194,10 +194,8 @@ static inline void print_state(struct hvsi_struct *hp)
>  		"HVSI_WAIT_FOR_MCTRL_RESPONSE",
>  		"HVSI_FSP_DIED",
>  	};
> -	const char *name = state_names[hp->state];
> -
> -	if (hp->state > ARRAY_SIZE(state_names))
> -		name = "UNKNOWN";
> +	const char *name = (hp->state < ARRAY_SIZE(state_names))
> +		? state_names[hp->state] : "UNKNOWN";
>  
>  	pr_debug("hvsi%i: state = %s\n", hp->index, name);
>  #endif /* DEBUG */
> -- 
> 1.6.0.4
