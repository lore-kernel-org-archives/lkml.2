Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab1J3J7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 05:59:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57689 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1J3J7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 05:59:22 -0400
Date: Sun, 30 Oct 2011 10:59:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
Message-ID: <20111030095918.GA19676@one.firstfloor.org>
References: <1319772566.6759.27.camel@deadeye> <1319777025.23112.67.camel@edumazet-laptop> <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com> <1319803781.23112.113.camel@edumazet-laptop> <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com> <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com> <1319813252.23112.122.camel@edumazet-laptop> <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com> <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com> <1319964754.13597.26.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319964754.13597.26.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define ACCESS_AT_MOST_ONCE(x)			\
> +	({	unsigned long __y;		\

why not typeof here?

> +		asm("":"=r" (__y):"0" (x));	\
> +		(__force __typeof__(x)) __y;	\
> +	})
> +

-Andi
