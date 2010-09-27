Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab0I0RSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:18:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759480Ab0I0RR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <20100927162610.GA18373@jurassic.park.msu.ru>
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
 <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk>
 <20100927075828.GA15344@jurassic.park.msu.ru> <20100927121227.GB19804@ZenIV.linux.org.uk>
 <20100927124624.GC19804@ZenIV.linux.org.uk> <20100927162610.GA18373@jurassic.park.msu.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Sep 2010 10:10:40 -0700
Message-ID: <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, rth@twiddle.net,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 9:26 AM, Ivan Kokshaysky
<ink@jurassic.park.msu.ru> wrote:
>
> Looks like we need to drop HAE bits from SAVE_ALL/RESTORE_ALL, which
> benefits (1) and automatically fixes (3), and do the entire IO sequences
> in (2) with disabled interrupts (if HAE is involved).

No can do.

HAE is used in user space too (the X server), and it depends on the
kernel restoring HAE over interrupts and system calls, afaik.

I'm also pretty certain that all SMP machines either don't have HAE at
all, or have a per-CPU HAE in hardware (and then it's possible that we
screw it up in software, of course). Anything else would be too broken
for words. Can somebody find documentation saying otherwise?

                        Linus
