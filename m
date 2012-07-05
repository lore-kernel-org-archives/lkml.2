Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2GEVpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 17:45:16 -0400
Received: from waste.org ([173.11.57.241]:35521 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab2GEVpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 17:45:15 -0400
Message-ID: <1341524712.4020.1330.camel@calx>
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Date: Thu, 05 Jul 2012 16:45:12 -0500
In-Reply-To: <CA+55aFxk3eViz1-CuuHf8xxTgLth376K_cOKAtAj0waXAz+GWg@mail.gmail.com>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	 <1341511933-11169-8-git-send-email-tytso@mit.edu>
	 <CA+55aFxk3eViz1-CuuHf8xxTgLth376K_cOKAtAj0waXAz+GWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 11:35 -0700, Linus Torvalds wrote:
> If Intel's rng really isn't trustworthy, they'll get a *huge* black
> eye for it. It would be a total PR disaster for Intel, so they have
> huge incentives to be trustworthy.

Just like the huge black eye that _every major US telecom company_ got
when they got caught colluding with the NSA to spy on Americans in
obvious violation of US law? You'll recall that it was such a *huge* PR
disaster... that they're all still doing it today(!), that Congress
retroactively changed the law(!), and that the whistleblower was
indicted for espionage(!).

I agree that Intel's hardware is very probably not backdoored, but
that's simply not a standard by which threats should be measured in this
field. Treating a backdoor scenario as outside the realm of possibility
based on appeals to reputation given such obvious, massive, and recent
precedent to the contrary is... not a typical security mindset, to put
it mildly.

Lastly, note that it would take a single well-placed engineer to insert
the backdoor, by just masking out some parts of the AES data path. No
collusion by Intel at a corporate level is actually even necessary.

Generating random bytes is not so performance critical that you should
trade all protection from potential threats for Gbps of throughput. 
By all means, USE the HWRNG's output, but not raw. Mix it with other
entropy sources first.

-- 
Mathematics is the supreme nostalgia of our time.


