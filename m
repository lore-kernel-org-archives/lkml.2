Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0CQKOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:14:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:40798 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0CQKOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:14:48 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: munroesj@us.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
In-Reply-To: <4BA09D5D.5090602@redhat.com>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com>
	 <1268816179.2335.187.camel@pasglop>  <4BA09D5D.5090602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 21:13:45 +1100
Message-ID: <1268820825.2335.190.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 02:14 -0700, Ulrich Drepper wrote:
> >> I believe that should cover it, at least for powerpc, possibly for
> other
> >> archs too though as I said, I may have missed something there.
> 
> How can this possibly be the case?  This will screw people who
> currently
> work around the ppc limitations of the existing syscall.

No it won't. As I said, it will work for both cases. The problem is a
register pair alignment problem. If the alignment is corrected with the
trick I proposed, 64-bit values will end up in the right pair, but
manually worked-around cases where the value is already broken up will
-also- end up in the right pair.

The problem with syscall() as it is is that it skews the arguments by 1
register, which causes the compiler to skip a register when generating
the call for a 64-bit value. By doing the trick I propose, that skew
will be gone, both 32 and 64 bit arguments will end up where expected.

Cheers,
Ben.


