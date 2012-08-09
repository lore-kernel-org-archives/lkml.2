Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab2HIXRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:17:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33361 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2HIXRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:17:24 -0400
Date: Thu, 09 Aug 2012 16:17:22 -0700 (PDT)
Message-Id: <20120809.161722.978110433246227213.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        maze@google.com, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, pyu@redhat.com
Subject: Re: [PATCH net-next] time: jiffies_delta_to_clock_t() helper to
 the rescue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344496433.28967.443.camel@edumazet-glaptop>
References: <1344496433.28967.443.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 09 Aug 2012 09:13:53 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> Various /proc/net files sometimes report crazy timer values, expressed
> in clock_t units.
> 
> This happens when an expired timer delta (expires - jiffies) is passed
> to jiffies_to_clock_t().
> 
> This function has an overflow in :
> 
> return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
> 
> commit cbbc719fccdb8cb (time: Change jiffies_to_clock_t() argument type
> to unsigned long) only got around the problem.
> 
> As we cant output negative values in /proc/net/tcp without breaking
> various tools, I suggest adding a jiffies_delta_to_clock_t() wrapper
> that caps the negative delta to a 0 value.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Maciej ¯enczykowski <maze@google.com>

Applied, thanks Eric.
