Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab1D1Pdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:33:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50076 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1D1Pdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ESGQPe5D7o1ANdt1xJ4/LwxE347IRSVlq9vf4s16bcbQXAsNXq4NZnA7lhgS7n1SdH
         oeTeLiGyrMpE7vWyjNYyMVV5SqdXipyeCeIQyOBp4KVJfK20oHz5sIcA8lpRxcPlu2HE
         cVmu8NhGtXGsMz743uAvfqt7alw8UtnS/M23o=
MIME-Version: 1.0
In-Reply-To: <20110429002847.3D77.A69D9226@jp.fujitsu.com>
References: <20110429002847.3D77.A69D9226@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 12:33:50 -0300
Message-ID: <BANLkTim4RWbkEMuUDcGG5y-ApznqX+31uw@mail.gmail.com>
Subject: Re: [PATCH v2] cpumask: add cpumask_var_t documentation
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:27 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> cpumask_var_t has one nortable difference against cpumask_t.
> This patch adds the explanation.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/cpumask.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 1e40dd0..471c98a 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -617,6 +617,20 @@ static inline size_t cpumask_size(void)
>  *       ... use 'tmpmask' like a normal struct cpumask * ...
>  *
>  *     free_cpumask_var(tmpmask);
> + *
> + *
> + * However, one notable exception is there. cpumask_var_t is allocated
> + * only nr_cpu_ids bits

Maybe, instead of "is allocated only", "allocates only" ?


> (in the other hand, real cpumask_t always has
> + * NR_CPUS bits). therefore You don't have to dereference cpumask_var_t.

s/therefore You/Therefore you/ ?

> + *
> + *     cpumask_var_t tmpmask;
> + *     if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
> + *             return -ENOMEM;
> + *
> + *     var = *tmpmask;
> + *
> + * This code makes NR_CPUS length memcopy and bring memroy corruption.

/s/memroy/memory

You are saying that I should not use this code? I'm confused, could
you explain a little bit?

> + * You have to use cpumask_copy() instead.
>  */

I don't get this. :(


>  #ifdef CONFIG_CPUMASK_OFFSTACK
>  typedef struct cpumask *cpumask_var_t;
> --
> 1.7.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
