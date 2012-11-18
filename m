Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KRTDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:03:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2KRTDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:03:36 -0500
Date: Sun, 18 Nov 2012 14:03:32 -0500 (EST)
Message-Id: <20121118.140332.1273544560009594278.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, monstr@monstr.eu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
References: <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
	<20121118054510.GE16916@ZenIV.linux.org.uk>
	<CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Nov 2012 08:45:43 -1000

> On Sat, Nov 17, 2012 at 7:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Linus, do you have any objections to the above?  FWIW, I've a tentative
>> patchset in that direction (most of it from the last cycle); right now
>> it + stuff currently in signal.git#for-next is at -3.4KLoC and I hadn't
>> dealt with the biarch side of things yet...
> 
> I have absolutely no objections. sigaltstack has always been kind of
> messy, and made worse by the fact that it gets effectively no testing
> (because it's generally not used by normal code and even code that
> uses it tends to use it only for very uncommon events). So forcing all
> the sigaltstack code into generic code and at least avoiding the
> "different architectures can get things subtly - or not so subtly -
> wrong in different ways" sounds like a good thing.

FWIW, if folks are looking for testcases there are a small number in
glibc, a quick grep shows:

nptl/tst-cancel20.c
nptl/tst-cancel21.c
nptl/tst-signal6.c
debug/tst-longjmp_chk2.c

LTP probably has a bunch too.
