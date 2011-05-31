Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab1EaSey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:34:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1EaSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:34:53 -0400
Date: Tue, 31 May 2011 20:34:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Message-ID: <20110531183448.GA27166@one.firstfloor.org>
References: <cover.1306851090.git.luto@mit.edu> <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
> +When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
> +Why:	Having user-executable code at a fixed address is a security problem.
> +	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
> +	make the time() function slower on glibc versions 2.13 and below.

I disagree with this description (and the whole idea really)

First it's time+gettimeofday+vgetcu, not just time.

A more accurate description is 

"will make all x86-64 Linux programs written to the original pre
vDSO syscall ABI significantly slower"

And the assumption that all world is using glibc is still as bad
as it was on the first po.st

And it's still a bad idea. Especially since there's a much better
alternative anyways for the "security problem" which has none of 
these drawbacks.

-Andi
