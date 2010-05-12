Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0ELAFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:05:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:57482 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab0ELAFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:05:48 -0400
Subject: Re: [PATCH 07/22] lmb: Add lmb_to_bootmem()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BE78C37.5080103@oracle.com>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
	 <1273331860-14325-8-git-send-email-yinghai@kernel.org>
	 <1273461193.23699.9.camel@pasglop>  <4BE78C37.5080103@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 10:03:36 +1000
Message-ID: <1273622616.21352.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-09 at 21:31 -0700, Yinghai wrote:
> > This is clumsy. Doesn't work with NUMA either. Also,
> 
> it works NUMA. for x86 we managed to call that one time from
> 2.6.34-rc1. (still called early_res_to_bootmem().
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1842f90cc98625d4d9bf8f8b927f17705ceb4e9c
> 
> > reserve_bootmem_generic() only exists on x86 afaik.
> 
> previous patch add weak version 
> [PATCH 06/22] bootmem, x86: Add weak version of
> reserve_bootmem_generic

It might work on x86, it won't work on sparc as far as I understand. In
any case, I don't think that should be in lmb.c, that's boilerplate crap
that eventually will go away.

One thing you don't seem to get is that several archs already have some
code to move from lmb to bootmem.

The right approach when making something "generic" like that is not to
make up another one deep into x86 gunkyness and make -that- generic
ignoring the existing implementations.

Instead, make sure that the existing implementations are in sync, and
then move -that- to a generic place, eventually adding (in a separate
patch) the changes needed by x86 if any.

Cheers,
Ben.


