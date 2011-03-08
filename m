Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1CHVaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:30:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:45088 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1CHVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:30:10 -0500
Subject: Re: RFC: x86: kill binutils 2.16.x?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
References: <4D6E8932.1010405@zytor.com>
	 <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
	 <4D6EB07C.5040004@zytor.com>
	 <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
	 <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
	 <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 08:28:36 +1100
Message-ID: <1299619716.22236.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 14:57 -0500, Kyle Moffett wrote:
> 
> Specifically the e500 doesn't have a normal PowerPC FPU, it has a
> custom FPU built using extended integer registers instead, and it
> happens to borrow the AltiVec opcode range to do it.
> 
> When trying to port Debian to the platform we were getting SIGILL's
> all over the place until binutils got updated to reject all of the
> unsupported opcodes on this particular platform.  Now of course we get
> build errors, but that's a lot easier to debug and fix. :-D
> 
> Basically, binutils no longer supports "-many" (because too many
> opcodes conflict), and the test itself would fail anyways (because
> "dssall" is not valid on "any" PowerPC). 

Note that this freescale "SPE" fiasco is just that ... a fiasco :-) I
don't think there's that many cases of opcode overlap outside of it.

Now regarding the kernel, the best is probably for nasty cases like that
to use hand coded opcodes (see ppc-opcodes.h) and stick to a more
"generic" setting for binutils, since it should be possible to build
kernels that support multiple types of BookE CPUs with different
floating point units.

Cheers,
Ben.


