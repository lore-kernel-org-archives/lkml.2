Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2GETum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:50:42 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37104 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2GETul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:50:41 -0400
Date: Thu, 5 Jul 2012 15:50:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net, stable@kernel.org
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
Message-ID: <20120705195025.GH31225@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	w@1wt.eu, ewust@umich.edu, zakir@umich.edu, greg@kroah.com,
	mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
	tglx@linutronix.de, davem@davemloft.net, stable@kernel.org
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-8-git-send-email-tytso@mit.edu>
 <CA+55aFxk3eViz1-CuuHf8xxTgLth376K_cOKAtAj0waXAz+GWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxk3eViz1-CuuHf8xxTgLth376K_cOKAtAj0waXAz+GWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 11:35:12AM -0700, Linus Torvalds wrote:
> 
> If "get_random_bytes()" doesn't use the hw rng when it exists, it is
> broken. It's that simple.
> 

It is using the HW RNG when it exists; it will ultimately call
xfer_secondary_pool, which will mix in inputs from the hw rng.  So we
do get all of the security of the HW RNG.  Currently all of the
callers of the get_random_bytes() have to accomodate the fact that the
HW RNG might not be there (on non-Intel architectures if nothing
else), so get_random_bytes() can't be used in any hot paths as it is.

So we *are* using the hw rng; we're just not using it to the exclusion
of anything else.

						- Ted
