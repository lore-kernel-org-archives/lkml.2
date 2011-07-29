Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1G2VQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:16:16 -0400
Received: from waste.org ([173.11.57.241]:51200 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1G2VQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:16:15 -0400
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
	 <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 16:16:11 -0500
Message-ID: <1311974171.20898.393.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 13:37 -0700, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Add support for architecture-specific hooks into either the blocking
> or the nonblocking random pools.  These hooks are defined to return
> the number of bytes of randomness produced (similar to a read() system
> call.)  They could also potentialy be used to inject randomness on
> demand while continuing to use the pool system, by calling a suitable
> injection interface and returning 0.

I have already NAKed this approach in no uncertain terms.

What if the next fancy hardware RNG with its own crypto hardening[1]
that shows up is not a special CPU instruction or indeed not even
arch-specific? It could just as easily be a USB or i2c or PCI device.
There's no reason to think the two notions are connected AT ALL. Your
whole notion of an 'architectural random source' is just plain wrong.
The right way to do this is to add a generic extension to the existing
hardware RNG design.

If you want to make forward progress, spend the half a day to implement
a standard HWRNG driver so people with your hardware have basic
functionality, then come back and we'll discuss implementing a trusted
fast path API to HWRNG drivers. If you had done this weeks ago when I
first asked you to do that, you would have had no problem getting basic
support into the current merge window.

[1] hopefully auditable without an electron microscope!
-- 
Mathematics is the supreme nostalgia of our time.


