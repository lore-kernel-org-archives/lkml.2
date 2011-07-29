Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1G2VFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:05:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37437 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1G2VFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:05:43 -0400
Message-ID: <4E3320A2.1040808@pobox.com>
Date: Fri, 29 Jul 2011 17:05:38 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Direct support for the x86 RDRAND instruction
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:37 PM, H. Peter Anvin wrote:
> From: "H. Peter Anvin"<hpa@linux.intel.com>
>
> This is a proposed patchset to enable the new x86 RDRAND instruction,
> labelled "Bull Mountain Technology" by Intel.  It is a different beast
> than any other hardware random number generator that I have personally
> encountered: it is not just a random number source, but contains a
> high bandwidth random number generator, an AES cryptographic whitener,
> and integrity monitoring all in hardware.
>
> For technical documentation see:
>
> http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/
>
> This proposed patchset enables RDRAND bypass for current users of the
> nonblocking random pool (that is, for /dev/urandom and its equvalent
> in-kernel users) but not for the blocking pool (/dev/random).  This is
> because RDRAND, although reseeded way more frequently than what is
> practical to do in software, is technically a nonblocking source that
> can behave as a PRNG.  It can be used as a source for randomness for
> /dev/random, but that is not addressed by this patchset.

This does not cover the one question I [predictably] have:  why not do 
this in rngd, rather than the kernel?

Since many (all?) TPM chips include a random number generator, Dell has 
made sure that most distros have a useful copy of the rng-tools 
userspace pkg I've been maintaining.

It would seem straightforward to add this to rngd, and enable RDRAND on 
older distros and kernels, as well as current distros / kernels.  This 
also gets useful entropy to /dev/random as part of normal operation, 
rather than only merely speeding up /dev/urandom.

Though for the record, I do agree that this is a nice, small and clean 
kernel implementation.

	Jeff




