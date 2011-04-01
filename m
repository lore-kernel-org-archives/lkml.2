Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1DAQkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:40:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab1DAQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <201104011755.57412.arnd@arndb.de>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011554.07924.arnd@arndb.de> <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
 <201104011755.57412.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Apr 2011 09:39:38 -0700
Message-ID: <AANLkTikfBhCH5wrpYzKbws0F_UVaskhtN_SUGQ+hU8Ab@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 8:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Well, except that because of point 7, device trees are still inferior to
> having correct and complete information in hardware.

Oh, absolutely.

If you have discoverable hardware, use it.

But by "discoverable hardware" I mean something like PCI config
cycles. IOW, real hardware features. Not some code like

   if (board_signature_is(xyz)) {
     ...

that just maps some _other_ hardware knowledge (reading a SoC ID or
something) into an unrelated thing ("I know this SoC has these bits of
hardware").

So devicetree should never override actual "hardware tells me it
exists here". But you might well have a mapping from SoC ID's to a
compiled-in devicetree thing (this is largely what POWER does, iirc).

                Linus
