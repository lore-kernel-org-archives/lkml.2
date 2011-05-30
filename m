Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1E3Jxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:53:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1E3Jxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:53:44 -0400
Date: Mon, 30 May 2011 11:53:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530095333.GA8461@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530091536.GA2827@elte.hu>
 <1306747629.2029.397.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306747629.2029.397.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2011-05-30 at 11:15 +0200, Ingo Molnar wrote:
> > 
> > > I believe that this 'filtered randconfig' behaviour is now fairly much
> > > the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.
> > 
> > I use "make ARCH=i386 defconfig" and "make ARCH=x86_64 defconfig" all 
> > the time.
> 
> Good point. But shouldn't "make i386_defconfig" and "make
> x86_64_defconfig" do that?

Yeah, we could certainly fix (or extend?) kconfig to allow those 
forms too, if you would like to use them.

I personally prefer 'make ARCH=i386 defconfig' and 'make ARCH=x86_64 
defconfig' because it's a nice conceptual equivalent to:

	make ARCH=arm defconfig
	make ARCH=mips defconfig

et al.

'make ARCH=x86 defconfig' should probably default to the host bitness 
version, or always default to 64-bit - right now it defaults to 
i386_defconfig.

[ Note that some of the architectures are a bit weird there: for 
  example 'make ARCH=powerpc' will only work if you use a PPC 
  cross-compiler - but it generally works fine and i rely on that for 
  cross-build tooling. ]

As for your fix patch, is the wording i provided fine to you so i can 
commit it? I think we should treat it differently from any defconfig 
related fixes/enhancements and not delay it - the 2 years of delay 
was already too long IMHO! ;-)

Thanks,

	Ingo
