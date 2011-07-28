Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1G1OOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:14:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42522 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1G1OOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:14:05 -0400
Date: Thu, 28 Jul 2011 16:13:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110728141348.GB26379@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110727171015.GD19477@aftab>
 <4E3047D4.2000608@zytor.com>
 <20110728134416.GA26379@aftab>
 <4E316C06.2020609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E316C06.2020609@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:02:46AM -0400, H. Peter Anvin wrote:
> On 07/28/2011 06:44 AM, Borislav Petkov wrote:
> > On Wed, Jul 27, 2011 at 01:16:04PM -0400, H. Peter Anvin wrote:
> >>> + * Create a contiguous bitmask starting at bit position @lo and ending at
> >>> + * position @hi. For example
> >>> + *
> >>> + * GENMASK_ULL(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> >>> + */
> >>> +#define _GENMASK_T(cast, type, lo, hi) \
> >>> +       (((cast)(1##type << ((hi) - (lo) + 1)) - 1) << (lo))
> >>> +#define GENMASK(lo, hi)                _GENMASK_T(unsigned, U, lo, hi)
> >>> +#define GENMASK_UL(lo, hi)     _GENMASK_T(unsigned long, UL, lo, hi)
> >>> +#define GENMASK_ULL(lo, hi)    _GENMASK_T(unsigned long long, ULL, lo, hi)
> >>> +
> >>
> >> These really need to be usable from assembly language, too (in which
> >> case you of course need to not have the cast and suffix), so it probably
> >> should be defined in <linux/const.h> with the other constant macros.
> > 
> > How about that:
> > 
> > #define _GENMASK_T(cast, type, lo, hi) \
> > 	        ((_AT(cast, (_AC(1,type) << ((hi) - (lo) + 1))) - 1) << (lo))
> > #define GENMASK(lo, hi)         _GENMASK_T(unsigned, U, lo, hi)
> > #define GENMASK_UL(lo, hi)      _GENMASK_T(unsigned long, UL, lo, hi)
> > #define GENMASK_ULL(lo, hi)     _GENMASK_T(unsigned long long, ULL, lo, hi)
> > 
> > outside of __KERNEL__ scope?
> > 
> 
> Then everything needs another underscore.

You want them to be _GENMASK{,_UL,_ULL}? Why? Because they're "calling"
macros with a single underscore? Actually, I've always wondered on what
our exact rules on underscores are. I can deduce the nesting level of
macros based on number of underscores but what else?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
