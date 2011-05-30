Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1E3KGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:06:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1E3KGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:06:47 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 11:06:42 +0100
In-Reply-To: <20110530095333.GA8461@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530091536.GA2827@elte.hu>
	 <1306747629.2029.397.camel@i7.infradead.org>
	 <20110530095333.GA8461@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306750004.2029.413.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 11:53 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> > Good point. But shouldn't "make i386_defconfig" and "make
> > x86_64_defconfig" do that?
> 
> Yeah, we could certainly fix (or extend?) kconfig to allow those 
> forms too, if you would like to use them.

Those always worked. I actually *broke* it in my previous patch. Before
that, the 'i386_defconfig' never actually needed to *specify* that it
wanted CONFIG_64BIT=n, because that would never have been the default.
Adding '# CONFIG_64BIT is not set' to arch/x86/configs/i386_defconfig
fixes it.

> I personally prefer 'make ARCH=i386 defconfig' and 'make ARCH=x86_64 
> defconfig' because it's a nice conceptual equivalent to:
> 
> 	make ARCH=arm defconfig
> 	make ARCH=mips defconfig

No, ARCH= is just for cross-compiling. If you're *on* an ARM or MIPS
box, you don't need the ARCH= bit.

And it *doesn't* follow the pattern you seem to be looking for, because
it's *not* setting 32-bit or 64-bit compilation. ARM doesn't even *have*
64-bit support, but let's look at MIPS:

If you want a 64-bit MIPS kernel, you do something like
	make bigsur_defconfig 

If you want a 32-bit MIPS kernel, you do something like
	make ar7_defconfig

You *don't* set 'ARCH=mips32' or 'ARCH=mips64'; CONFIG_64BIT is just a
config option.

Of course, MIPS makes it more "interesting" because it doesn't do a
"generic" kernel that boots on more than one machine. PowerPC is
probably the better analogy. There, it's:

	make ppc_defconfig
and	make ppc64_defconfig

And still no 'ARCH=ppc' or 'ARCH=ppc64'. Those got killed off a long
time ago, when we merged the 32-bit and 64-bit code into arch/powerpc.

And, as before, you don't need the ARCH=powerpc if you are already on a
PowerPC box. That's just for cross-compilation.

-- 
dwmw2

