Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1G3W0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:26:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55679 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab1G3W0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:26:10 -0400
Date: Sat, 30 Jul 2011 18:25:49 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
Message-ID: <20110730222549.GL7361@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
 <1311974171.20898.393.camel@calx>
 <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
 <1312047959.20898.489.camel@calx>
 <CA+55aFyhdSADSuc2Honu0HG4zLQ7JtovsiTonfA=Cu70jqrFRQ@mail.gmail.com>
 <1312053234.20898.521.camel@calx>
 <CA+55aFwjx=E5fpO=gfx0ugPE2Cgd_NOtw1Kx52pbg4aQEgshRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwjx=E5fpO=gfx0ugPE2Cgd_NOtw1Kx52pbg4aQEgshRg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 09:29:18AM -1000, Linus Torvalds wrote:
> The fact is, even if you worry about some back door for the NSA, or
> some theoretical lack of perfect 32-bit randomness, we can pretty much
> depend on it. We still do our own hashing on top of whatever entropy
> we get out of rdrand, and we would still have all our other stuff.
> Plus the instruction is public and testable - if Intel did something
> wrong, they'll be *very* embarrassed.

Technically speaking, if Intel and the NSA were colluding together in
a competent way, we'd never know; it's not something that could be
tested.  Intel could have implemented a incrementing counter which was
initialized to some randomness, which was then encrypted by some NSA
secret algorithm with a secret key known only to the NSA.  We'd never
know, but it would be enough of a backdoor for the NSA to do what they
need to know.  The only way it could leak out is via the human
channel; if someone was upset enough about it that they send the
algorithm and secret key to wikileaks.

But yeah, we can definitely depend on it if it is hashed into the pool
and it's on top of everything else that we do.  And it's all a matter
of how paranoid you want to be.  If you are working for government,
where the NSA is by definition one of the good guys, then using rdrand
directly is completely not a problem.  If you are working for any
other government agency, you'd probably want to mix it into the a
random pool just to feel better about implicitly trusting Intel.

So I agree with Linus here.

						- Ted
