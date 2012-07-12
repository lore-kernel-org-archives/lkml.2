Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2GLGPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:15:14 -0400
Received: from ozlabs.org ([203.10.76.45]:37045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab2GLGPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:15:10 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <20120711105335.GD22437@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120710101018.GE15120@arm.com> <20120710163358.6ae4a576@pyramind.ukuu.org.uk> <201207101652.18401.arnd@arndb.de> <877guarhpi.fsf@rustcorp.com.au> <20120711105335.GD22437@arm.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 12 Jul 2012 11:38:08 +0930
Message-ID: <87y5mppw8n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 11:53:35 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> Hi Rusty,

Hi Catalin,

        This is fun!

> On Wed, Jul 11, 2012 at 06:26:49AM +0100, Rusty Russell wrote:
> > I know it's a crazy idea, but why don't we try some actual analysis?
> 
> This kind of analysis is not relevant. It's not like you can use a tool
> to just mix the lines from one file with another and get a merged port.

Whether a tool or human would do it, using some methodology to measure
similarity of two ports seems more informative than relying on the gut
feel of developers.

> The tool claims unicore32 shares 57% with arch/arm. It gets confused in
> the same way because unicore32 started with the ARM port as the code
> base. Do we want it merged with arch/arm based on hashmatch?

It doesn't "get confused"; it means exactly what it says.  Sure, it's
rough, but it's unbiased.

And it indicates that arch/aarch64 is as related to arch/arm as
arch/unicore32 is, ie. no more than expected from an arm-derived port.
(I actually get 56% for unicore32, 52% for aarch64).

Thus I consider my previous position proven incorrect: aarch64 should be
its own tree.

> This tool also shows that pretty much most of the atomic.h file in
> AArch64 is the same with AArch32. That's completely wrong as the
> assembly syntax is different for the two architectures (even the asm
> comment has changed from @ to //). That's a file that can never be
> shared.

That's why I subtracted a randomly-chosen other arch (sparc) to try to
eliminate such boilerplate similarities.

Cheers,
Rusty.
