Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2IQRG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:06:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab2IQRGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:06:24 -0400
Message-ID: <50575855.8040308@zytor.com>
Date: Mon, 17 Sep 2012 10:05:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
References: <504DEA1B020000780009A277@nat28.tlf.novell.com> <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org> <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com> <5056F04B020000780009BAF9@nat28.tlf.novell.com> <20120917100046.GA32463@gmail.com> <CA+55aFwKkW7+Xv4-36JsbR7rDyorC8xcTsL_XnYCq=XNTZeJFw@mail.gmail.com>
In-Reply-To: <CA+55aFwKkW7+Xv4-36JsbR7rDyorC8xcTsL_XnYCq=XNTZeJFw@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:00 AM, Linus Torvalds wrote:
\>
> As Jan already pointed out, I really want more than that.
> 
> The *conditions* for selecting X86_TZCNT have to be sane too.
> 
> I really think that "32-bit generic kernel" is totally and completely
> a wrong choice for enabling this. A 32-bit setup has exactly two
> relevant cases:
> 
>  - old CPU's that don't support TZCNT anyway
>  - new CPU's where the user doesn't care about performance (things
> like HIGHMEM will have killed it much more than TZCNT etc ever will)
> 
> and in neither case is the TZCNT instruction relevant.
> 
> Even for the 64-bit case, I really don't see why "generic" should pick
> it up either. The fact that we don't have many CPU optimization
> choices for x86-64 is not an excuse to then overload "generic" with
> that kind of choice, I think.
> 
> So I really objected not only to the ugly and unreadable conditionals,
> I objected to the criteria for them too.
> 

Honestly, I don't see a reason to not do this unconditionally.  On
anything but (pre-686-era) extremely old CPUs the cost of the extra
prefix is zero.  On the really old CPUs the cost of the BSF instruction
will dwarf the penalty cycle for the extra prefix, so the whole
mechanism around doing it conditionally seems pointless.

	-hpa


