Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968077Ab2ERVlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:41:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47915 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968043Ab2ERVli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:41:38 -0400
Message-ID: <4FB6C1F7.1010307@zytor.com>
Date: Fri, 18 May 2012 14:41:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <CA+55aFwyem9KoPMhYkE-vcaUDqgP9g7arHbmD-mMHMSKXaRBOw@mail.gmail.com> <CA+55aFx4sEQT=U4DBULeo9=3piOx_pQUws92ovKV5bKsu3hQQQ@mail.gmail.com> <201205182131.29353.arnd@arndb.de>
In-Reply-To: <201205182131.29353.arnd@arndb.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 02:31 PM, Arnd Bergmann wrote:
> 
> However, in the kernel we *always* copy the fields one by one for compat
> mode, even for the architectures that have identical layout between 32 and
> 64 bit, and at least one libc implementation that I've seen (IIRC uClibc)
> hardcodes the data structure to be the same as x86, with the padding
> after the 'long', for all architectures. When I introduced the asm-generic
> version of this, we had a discussion about whether we should try to use
> the version with the "correct" padding but in the end decided to just use
> the x86 version because that is what most big-endian architectures do
> anyway.
> 

Ouch.  Fail.  asm-generic should be about what is the right thing going
forward.

	-hpa


