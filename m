Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1BGGN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:13:27 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40257 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab1BGGN0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:13:26 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1295834493-5019-5-git-send-email-ccross@android.com><1295968464.10109.264.camel@e102109-lin.cambridge.arm.com><20110125154133.GB17280@n2100.arm.linux.org.uk><1295979242.10109.308.camel@e102109-lin.cambridge.arm.com><2f97ec8a084e590220e1548fc927b60e@mail.gmail.com><-8932138696981683633@unknownmsgid><AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com><20110204234331.GF8732@n2100.arm.linux.org.uk><AANLkTi=fHnivHXHnYrQvdP6JWbEA3t1X3DuBxj5gN3H0@mail.gmail.com><1bebe4b5c8590059b70a146d5486fa6a@mail.gmail.com><20110205094730.GA23965@n2100.arm.linux.org.uk><cb528285e8aa8cdda01d7ced0121b2cf@mail.gmail.com>
 <AANLkTik_r4k_5o+F47vRbGPcWLwfgHgWqhym49XfhBZ9@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <AANLkTik_r4k_5o+F47vRbGPcWLwfgHgWqhym49XfhBZ9@mail.gmail.com>
Thread-Index: AcvFUth5p8lcRsDnRGyHG55pYP0LewBOlGYA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Mon, 7 Feb 2011 11:43:23 +0530
Message-ID: <97f50b099a5ce498eea7a7abfa59eca6@mail.gmail.com>
Subject: RE: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support forre-enabling l2x0
To: Colin Cross <ccross@android.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ccross@google.com [mailto:ccross@google.com] On Behalf Of
> Colin Cross
> Sent: Saturday, February 05, 2011 10:06 PM
> To: Santosh Shilimkar
> Cc: Russell King - ARM Linux; Will Deacon; Catalin Marinas; Linus
> Walleij; konkers@android.com; Tony Lindgren; linux-
> kernel@vger.kernel.org; linux-tegra@vger.kernel.org; olof@lixom.net;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support
> forre-enabling l2x0
>
> On Sat, Feb 5, 2011 at 4:41 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
[....]

> >> On Sat, Feb 05, 2011 at 01:21:24PM +0530, Santosh Shilimkar
> wrote:
> >> > GIC save/restore on OMAP follows different strategy. There is a
> >> > Predefined layout to save content and restore is done
> atomically
> >> > by boot ROM code.
> >> > L2 cache also same case. Only AUXCTRL needs to be programmed on
> >> > wakeup from low power mode and that too with secure call. Rest
> >> > of the registers are managed by boot ROM code.
> >> >
> >> > TWD is already managed through framework. Othe CPU low power
> >> > sequence is very small and OMAP has restrictions on the last
> >> > core to go down and first to wakeup.
> >> >
> >> > So at least I don't see any use of common notifiers for GIC
> >> > and L2 will help OMAP lower power code.
> >>
> >> What this means is that we're going to end up littering things
> like
> >> GIC
> >> and other stuff with lots of individual SoC specific code to save
> >> state
> >> into individual SoC specific structures.  This is not sane, and
> >> we're
> >> not going to corrupt generic code with SoC specific code.
> >
> > Fully agree and hence flagged it early.
> >
[....]

>
> Would putting dummy values in the areas the boot ROM uses and then
> letting the common GIC code restore over them cause any problems?

Ya there are few issue. GIC and GIC OMAP extension are managed
together by BOOT ROM code. It's far optimal save and restore. Only
needed registers from OMAP point of view are saved/restored.
And for such reasons I would not like to use dummy stuff.

Regards
Santosh
