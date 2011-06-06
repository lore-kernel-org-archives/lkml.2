Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1FFMTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:19:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48513 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1FFMTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:19:51 -0400
Date: Mon, 6 Jun 2011 08:19:37 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606121937.GI7180@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Jan Beulich <JBeulich@novell.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Mikael Pettersson <mikpe@it.uu.se>,
	Andi Kleen <andi@firstfloor.org>, Brian Gerst <brgerst@gmail.com>,
	Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
	pageexec@freemail.hu
References: <cover.1307292171.git.luto@mit.edu>
 <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606102419.GA837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606102419.GA837@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:24:19PM +0200, Ingo Molnar wrote:
>  
> -What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
> +What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
>  When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
> -Why:	Having user-executable code at a fixed address is a security problem.
> -	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
> +Why:	Having user-executable syscall invoking code at a fixed addresses makes
> +	it easier for attackers to exploit security holes.
> +	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
>  	make the time() function slower on glibc versions 2.13 and below.
>  Who:	Andy Lutomirski <luto@mit.edu>

I'd suggest 2013 or 2014, at least.  People using Ubuntu LTS and RHEL
6 are stuck back at glibc 2.11, and many of those users do like being
able to upgrade to newer kernels.  And there are probably are a large
number of static binaries around.

Maybe in 2012 or so we change the to be 'no' (and I'd suggest adding a
comment in the feature-removal-schedule.txt file that this will also
break static binaries).

Regards,

						- Ted
