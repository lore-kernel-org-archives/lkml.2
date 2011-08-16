Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1HPHnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:43:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35413 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1HPHnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:43:15 -0400
Date: Tue, 16 Aug 2011 09:43:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
Message-ID: <20110816074309.GA31781@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	melwyn lobo <linux.melwyn@gmail.com>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
 <CAHSGOuuova1kB77_X6bQ3R7E5N2PLhGsmxqb6kd48EDZ9yEPug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHSGOuuova1kB77_X6bQ3R7E5N2PLhGsmxqb6kd48EDZ9yEPug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 12:49:28PM +0530, melwyn lobo wrote:
> We would rather use the 32 bit patch. Have you already got a 32 bit
> patch.

Nope, only 64-bit for now, sorry.

> How can I use sse3 for 32 bit.

Well, OTTOMH, you have only 8 xmm regs in 32-bit instead of 16, which
should halve the performance of the 64-bit version in a perfect world.
However, we don't know how the performance of a 32-bit SSE memcpy
version behaves vs the gcc builtin one - that would require benchmarking
too.

But other than that, I don't see a problem with having a 32-bit version.

> I don't think you have submitted 64 bit patch in the mainline.
> Is there still work ongoing on this.

Yeah, we are currently benchmarking it to see whether it actually makes
sense to even have SSE memcpy in the kernel.

-- 
Regards/Gruss,
    Boris.
