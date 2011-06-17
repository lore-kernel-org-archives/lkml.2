Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab1FQRWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:22:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40567 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507Ab1FQRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:22:39 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
X-Yow: --- I have seen the FUN ---
Date: Fri, 17 Jun 2011 19:22:35 +0200
In-Reply-To: <BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com> (Geert
	Uytterhoeven's message of "Thu, 16 Jun 2011 21:45:11 +0200")
Message-ID: <m2sjr8gyp0.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> This is the WARN_ONCE(!irqs_disabled()) check.
>
> static inline bool arch_irqs_disabled_flags(unsigned long flags)
> {
>         return (flags & ~ALLOWINT) != 0;

That should be

          return (flags & 0x700) == 0x700;

It doesn't make sense to use ALLOWINT here, since arch_local_irq_disable
doesn't use it either.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
