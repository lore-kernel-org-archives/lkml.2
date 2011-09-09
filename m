Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab1IIPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:36:00 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:59167
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958Ab1IIPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:35:59 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz98dKzz1202h1082kzzz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR9HZT-02-B5F-02
X-M-MSG: 
Date: Fri, 9 Sep 2011 17:35:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110909153553.GA12448@gere.osrc.amd.com>
References: <20110812195220.GA29051@elte.hu>
 <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu>
 <20110816121604.GA29251@aftab>
 <4E5FA18A.7010205@gmail.com>
 <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
 <20110908083551.GA5646@liondog.tnic>
 <4E689FC5.8010005@gmail.com>
 <20110909081407.GA29251@liondog.tnic>
 <CA+55aFy5QOwQXqHkOkoMU_Lg6DrhrwVpMx4R0kFTnKqmACGy6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFy5QOwQXqHkOkoMU_Lg6DrhrwVpMx4R0kFTnKqmACGy6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 07:39:18AM -0700, Linus Torvalds wrote:
> Kernel memcpy's are basically almost always smaller than a page size,
> because that tends to be the fundamental allocation size.

Yeah, this is what my trace of a kernel build showed too:

Bytes   Count
=====   =====

...

224     3
225     3
227     3
244     1
254     5
255     13
256     21708
512     21746
848     12907
1920    36536
2048    21708

OTOH, I keep thinking that copy_*_user might be doing bigger sizes, for
example when shuffling network buffers to/from userspace. Converting
those to SSE memcpy might not be as easy as memcpy itself, though.

> Yes, there are exceptions that copy into big vmalloc'ed buffers, but
> they don't tend to matter. Things like module loading etc.

Too small a number of repetitions to matter, yes.

-- 
Regards/Gruss,
Boris.

