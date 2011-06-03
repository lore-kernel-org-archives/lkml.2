Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1FCXOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab1FCXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:14:19 -0400
Date: Fri, 3 Jun 2011 16:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] cs5535 mfgpt - fix wrong if condition
Message-Id: <20110603161415.49031357.akpm@linux-foundation.org>
In-Reply-To: <BANLkTimR2ggkjDiB9fZDuHJOuFX1Pb=rMw@mail.gmail.com>
References: <BANLkTimR2ggkjDiB9fZDuHJOuFX1Pb=rMw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 19:08:06 +0000
Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> From: Christian Gmeiner <christian.gmeiner@gmail.com>
> 
> This patch fixes the wrong if condition for the check if the
> requested timer is available.
> 
> The bitmap avail is used to store if a timer is used already.
> test_bit() is used to check if the requested timer is
> available. If a bit in the avail bitmap is set it means that the
> timer is available.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  drivers/misc/cs5535-mfgpt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
> index e01e08c..bc685bf 100644
> --- a/drivers/misc/cs5535-mfgpt.c
> +++ b/drivers/misc/cs5535-mfgpt.c
> @@ -174,7 +174,7 @@ struct cs5535_mfgpt_timer
> *cs5535_mfgpt_alloc_timer(int timer_nr, int domain)
>                 timer_nr = t < max ? (int) t : -1;
>         } else {
>                 /* check if the requested timer's available */
> -               if (test_bit(timer_nr, mfgpt->avail))
> +               if (!test_bit(timer_nr, mfgpt->avail))
>                         timer_nr = -1;
>         }
> 

What were the runtime effects of this bug?

(Please always include this information in the changelog when fixing things)

Thanks.
