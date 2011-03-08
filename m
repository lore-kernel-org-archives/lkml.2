Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab1CHV7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:59:09 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:21774
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab1CHV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:59:08 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz936eK1432N98dNzz1202hzz8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 8 Mar 2011 15:56:30 -0600
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Kyle Moffett <kyle@moffetthome.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Kumar Gala <kumar.gala@freescale.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        <linuxppc-dev@lists.ozlabs.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: x86: kill binutils 2.16.x?
Message-ID: <20110308155630.1eb6f67d@schlenkerla>
In-Reply-To: <1299619716.22236.32.camel@pasglop>
References: <4D6E8932.1010405@zytor.com>
	<alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
	<4D6EB07C.5040004@zytor.com>
	<alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
	<4D6ECBDB.6090307@zytor.com>
	<20110303083035.GB14854@elte.hu>
	<AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
	<1299619716.22236.32.camel@pasglop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 08:28:36 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2011-03-08 at 14:57 -0500, Kyle Moffett wrote:
> > 
> > Specifically the e500 doesn't have a normal PowerPC FPU, it has a
> > custom FPU built using extended integer registers instead, and it
> > happens to borrow the AltiVec opcode range to do it.
> > 
> > When trying to port Debian to the platform we were getting SIGILL's
> > all over the place until binutils got updated to reject all of the
> > unsupported opcodes on this particular platform.  Now of course we get
> > build errors, but that's a lot easier to debug and fix. :-D
> > 
> > Basically, binutils no longer supports "-many" (because too many
> > opcodes conflict), and the test itself would fail anyways (because
> > "dssall" is not valid on "any" PowerPC). 
> 
> Note that this freescale "SPE" fiasco is just that ... a fiasco :-) I
> don't think there's that many cases of opcode overlap outside of it.
> 
> Now regarding the kernel, the best is probably for nasty cases like that
> to use hand coded opcodes (see ppc-opcodes.h) and stick to a more
> "generic" setting for binutils, since it should be possible to build
> kernels that support multiple types of BookE CPUs with different
> floating point units.

Combined kernels between e500v1/2 and e500mc are currently not supported
for other reasons (current kconfig doesn't prohibit it, but it doesn't
work), such as a cache line size difference (a hardcoded L1_CACHE_BYTES is
used in various places for loops), an inability to enable SPE when e500mc
is enabled, etc.

Kumar recently internally said we're not going to bother making it work.
I'm inclined to agree, given you can't even run the same userspace (unless
you don't use hard floating point at all).  It's one thing to not want to
require a separate kernel for each board, but there's a point of
diminishing returns.

-Scott

