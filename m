Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1HEMBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:01:18 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:60176 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1HEMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:01:17 -0400
Date: Fri, 5 Aug 2011 20:00:33 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 0/3] Add support for architectural random number
	generator
Message-ID: <20110805120033.GA3967@gondor.apana.org.au>
References: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com> <1312147616-29125-1-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312147616-29125-1-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 02:26:53PM -0700, H. Peter Anvin wrote:
> This version of the patchset uses inlines with alternatives as
> proposed by Linus.  In order to avoid the issue of "random" vs
> "urandom", this hooks into *only* the kernel consumer interfaces
> get_random_bytes() and get_random_int(); this means that legacy users
> of /dev/urandom in userspace will not get direct use RDRAND, but those
> can be eventually converted to using RDRAND directly in userspace.
> 
> We can, of course, still both pools randomness via rngd or a future
> in-kernel mechanism as proposed by Matt.
> 
> Since there was a minor amount of confusion I want to clarify: RDRAND
> architecturally has weaker security guarantees than the documented
> interface for /dev/random, so we can't just replace all users of
> extract_entropy() with RDRAND.
> 
> Git tree also available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-rdrand.git rdrand-3
> 
> Again, for technical documentation see:
> 
> http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

FWIW these patches look good to me and I'm happy to take them
if Linus doesn't merge them directly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
