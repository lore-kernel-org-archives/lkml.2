Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1BYWLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:11:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140Ab1BYWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:11:11 -0500
MIME-Version: 1.0
In-Reply-To: <1298669593.3356.2.camel@odin>
References: <1298669593.3356.2.camel@odin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Feb 2011 14:10:49 -0800
Message-ID: <AANLkTim_bbv=WUd4DcB6fVmBy+-Yz1GNbDGga3rUeLNt@mail.gmail.com>
Subject: Re: [GIT PULL] Regulator fixes for 2.6.38
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 1:33 PM, Liam Girdwood <lrg@slimlogic.co.uk> wrote:
>
> Jesper Juhl (1):
>      regulator, mc13xxx: Remove pointless test for unsigned less than zero

So I absolutely detest patches like this.

It's not AT ALL pointless to write

   BUG_ON(x < 0 || x > XYZ);

because tests like that make it obvious that there are no sign issues,
without anybody ever having to worry about the sign. So it makes the
code more readable, and the intention more obvious. There is no
downside.

If it's an unsigned variable, the compiler can optimize away the test
against zero. In fact, it can do so even if it's signed (assuming XYZ
is a positive compile-time constant integer) and turn it into an
unsigned comparison.

So I did the pull, but I want to raise my objection to patches like
this. They are doubly wrong during the late -rc stage, but they are
wrong even otherwise.

If you have a compiler that warns about the test, you have a compiler
that is pure and utter shit. It's that simple.

                                    Linus
