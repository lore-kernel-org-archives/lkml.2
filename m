Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261Ab2C3S4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:56:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61734 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab2C3S4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:56:21 -0400
Subject: Re: [REGRESSION][PATCH V4 1/3] bpf jit: Make the
 filter.c::__load_pointer helper non-static  for the jits
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Matt Evans <matt@ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4F75CC63.10405@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75CC63.10405@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 20:56:15 +0200
Message-ID: <1333133775.2325.2426.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 17:08 +0200, Jan Seiffert wrote:
> The function is renamed to make it a little more clear what it does.
> It is not added to any .h because it is not for general consumption, only for
> bpf internal use (and so by the jits).
> 
> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>
> 

Missing "---" line separator (check Documentation/SubmittingPatches line
490)

You can check http://patchwork.ozlabs.org/patch/149683/ and see there is
a problem, compared to http://patchwork.ozlabs.org/patch/149441/ for
example

> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -40,8 +40,12 @@
>  #include <linux/reciprocal_div.h>
>  #include <linux/ratelimit.h>
>  
> -/* No hurry in this branch */
> -static void *__load_pointer(const struct sk_buff *skb, int k, unsigned int size)
> +/*
> + * No hurry in this branch
> + *
> + * Exported for the bpf jit load helper.
> + */

Seems good to me, maybe add a strong warning in the comment to say that
function prototype can NOT change without major surgery in ASM files,
since assembler wont catch the prototype change for us.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



