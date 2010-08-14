Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0HNNpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:45:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40240 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093Ab0HNNpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:45:02 -0400
Date: Sat, 14 Aug 2010 15:44:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Mike Frysinger <vapier.adi@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
Message-ID: <20100814134455.GA21218@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Chris Metcalf <cmetcalf@tilera.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20100517212138.GA21629@elte.hu>
 <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
 <4C65BF90.6000302@zytor.com>
 <AANLkTikaHsbdM0XSaHH1iE9p8cYE=YFM3an=+xB-JKgZ@mail.gmail.com>
 <4C65DF22.5090406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C65DF22.5090406@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, Aug 13, 2010 at 05:11:14PM -0700

> On 08/13/2010 02:59 PM, Mike Frysinger wrote:
> > 
> > but those targets still define CONFIG_GENERIC_HWEIGHT right ?  so at
> > the least, we should be wrapping the prototypes in linux/bitops.h with
> > that ...
> > 
> 
> Yes, I guess they do.

Actually, Mike's issue is valid, if I understand it correctly. From
looking at <arch/blackfin/include/asm/bitops.h>, Blackfin doesn't need
the generic software variants __sw_hweightXX at all, right?

In that case, <include/linux/bitops.h> is pulling in needlessly
unresolved symbols for arches which have their hw versions of
hweight and don't need sw variants. However, if you want to include
<asm-generic/bitops/hweight.h> and benefit from the compile-time
evaluation of the const hweight args, you're going to need to rename
the hweightXX() functions in <arch/blackfin/include/asm/bitops.h> to
__arch_hweightXX but that shouldn't be a problem I guess :).

Let me give your patch from couple of mails ago a quick spin...

-- 
Regards/Gruss,
    Boris.
