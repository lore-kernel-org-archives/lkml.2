Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556Ab2EWQxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:53:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51550 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab2EWQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:53:07 -0400
Date: Wed, 23 May 2012 18:53:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
Message-ID: <20120523165303.GB18284@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
	linux-kernel@vger.kernel.org, frank.arnold@amd.com,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	tglx@linutronix.de, linux-tip-commits@vger.kernel.org
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop>
 <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com>
 <1337790571.9783.28.camel@laptop>
 <4FBD10D5.6080602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBD10D5.6080602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:31:17AM -0700, H. Peter Anvin wrote:
> >>
> >> Actually we need a BIT() macro that works both
> >> on 32- and 64-bit. But that won't be that easy:
> >> http://lkml.indiana.edu/hypermail/linux/kernel/1010.1/02335.html
> >>
> >> And it should return UL for shift values < 32 and ULL otherwise.
> > 
> 
> Why do you want that behavior?  That seems bizarre...

I forgot to say "on 32-bit" above. So the sentence should've been:

"And it should return UL for shift values < 32 and ULL otherwise on
32-bit."

How about the following completely untested chunk:

#ifdef CONFIG_64BIT
#define BIT(nr)		(UC_64(1) << (nr))
#else
#define BIT(nr)	\
({ \
	unsigned _shift = (nr);	\
 	((_shift > 32) ? (U64_C(1) << _shift) : (U32_C(1) << _shift)); \
})
#endif

Ok? Too ugly? It still changes the return type of unsigned long to ULL
for shift values >= 32 and probably Linus doesn't want that...

Hmm.

-- 
Regards/Gruss,
    Boris.
