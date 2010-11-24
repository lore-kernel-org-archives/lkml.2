Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0KXOo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:44:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56405 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0KXOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:44:58 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eugene Teo <eugene@redhat.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] af_unix: limit unix_tot_inflight
References: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
	<1290553918.2866.80.camel@edumazet-laptop>
	<1290590335.3464.24.camel@edumazet-laptop>
Date: Wed, 24 Nov 2010 15:44:53 +0100
In-Reply-To: <1290590335.3464.24.camel@edumazet-laptop> (Eric Dumazet's
	message of "Wed, 24 Nov 2010 10:18:55 +0100")
Message-ID: <877hg2g4re.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> diff --git a/net/unix/garbage.c b/net/unix/garbage.c
> index c8df6fd..40df93d 100644
> --- a/net/unix/garbage.c
> +++ b/net/unix/garbage.c
> @@ -259,9 +259,16 @@ static void inc_inflight_move_tail(struct unix_sock *u)
>  }
>  
>  static bool gc_in_progress = false;
> +#define UNIX_INFLIGHT_TRIGGER_GC 16000

It would be better to define this as a percentage of
lowmem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
