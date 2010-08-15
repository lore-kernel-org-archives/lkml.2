Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0HOC1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 22:27:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44074
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451Ab0HOC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 22:27:45 -0400
Date: Sat, 14 Aug 2010 19:28:02 -0700 (PDT)
Message-Id: <20100814.192802.70207131.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinGy+-ELbVx_2WJ1wOJCsz4Rez26Q2Baisws9+C@mail.gmail.com>
References: <20100812.161050.246523792.davem@davemloft.net>
	<AANLkTinGy+-ELbVx_2WJ1wOJCsz4Rez26Q2Baisws9+C@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Aug 2010 11:05:54 -0700

> Anyway, the lock warning I do get seems to be networking-related, and
> is appended. Does this ring any bells? It could easily be something
> old: I turn on lock debugging only when I look for bugs (or when
> people point out bugs that I've created :^/ )
> 
> The only thing that seems to be related that google can find is pretty
> recent too: a report from Valdis Kletnieks about this apparently
> happening on e1000e too (Subject "mmotm 2010-08-11 - lockdep whinges
> at e1000e driver ifconfig up"). So it does seem to be pretty recent.
> 
> Hmm? Everything obviously still works, but judging by the lockdep
> report this might be a deadlock situation (lock taken in softirq _and_
> outside softirq without disabling bhs)

I'll take a look.
