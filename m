Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0JaVcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 17:32:24 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60913 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0JaVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 17:32:23 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>, Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH/RFC] m68k/sun3: Kill pte_unmap() warnings
References: <alpine.DEB.2.00.1010312135110.22279@ayla.of.borg>
X-Yow: YOW!!  Now I'm playing with my HOLOGRAPHIC ATOMIC SIMULATION LASER
 pinball machine!!  WORLD PEACE is in the BALANCE!!
Date: Sun, 31 Oct 2010 22:32:18 +0100
In-Reply-To: <alpine.DEB.2.00.1010312135110.22279@ayla.of.borg> (Geert
	Uytterhoeven's message of "Sun, 31 Oct 2010 21:38:35 +0100 (CET)")
Message-ID: <m2wroynj4t.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Which one is preferable?
>
> -------------------------------------------------------------------------------
> Since commit 31c911329e048b715a1dfeaaf617be9430fd7f4e ("mm: check the argument
> of kunmap on architectures without highmem"), we get lots of warnings like
>
> arch/m68k/kernel/sys_m68k.c:508: warning: passing argument 1 of ‘kunmap’ from incompatible pointer type
>
> As m68k doesn't support highmem anyway, open code the calls to kmap() and
> kunmap() (the latter is a no-op) to kill the warnings.

I prefer this one, it matches all architectures without CONFIG_HIGHPTE.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
