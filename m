Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0CRRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:21:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8183 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0CRRVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RYFK4C6Ij5JjTVPuDSkxrVVs5fo0vDe9CL0AUHhwXhvZzgtWYuM4Z9EuIwOe6g9n17
         dXOJSsDMazsxsn7xnBX/DNblQ70esVWLvWHE9V+ctgyDHZIjwPWws3AX2qb5LpzOQ8FH
         tkuccY2zX9hJAYFjVXPs9nbs04d/Uk6kHdKww=
MIME-Version: 1.0
In-Reply-To: <1268903124-10237-7-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
	 <1268903124-10237-7-git-send-email-akinobu.mita@gmail.com>
Date: Thu, 18 Mar 2010 19:21:18 +0200
X-Google-Sender-Auth: 95221e59562f104a
Message-ID: <84144f021003181021t54b0c5baj2947f007c1b48a62@mail.gmail.com>
Subject: Re: [PATCH 07/12] slab: convert cpu notifier to return encapsulate 
	errno value
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 11:05 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> By the previous modification, the cpu notifier can return encapsulate
> errno value. This converts the cpu notifiers for slab.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> Cc: Matt Mackall <mpm@selenic.com>
> Cc: linux-mm@kvack.org
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index a9f325b..d57309e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1324,7 +1324,7 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
>                mutex_unlock(&cache_chain_mutex);
>                break;
>        }
> -       return err ? NOTIFY_BAD : NOTIFY_OK;
> +       return notifier_from_errno(err);
>  }
>
>  static struct notifier_block __cpuinitdata cpucache_notifier = {
> --
> 1.6.0.6
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
