Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1G2SVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:21:51 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38206 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751651Ab1G2SVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:21:49 -0400
Date: Fri, 29 Jul 2011 11:21:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 28 ("copy_from_user_overflow"
 undefined)
Message-Id: <20110729112146.9459f48f.rdunlap@xenotime.net>
In-Reply-To: <4E32F2ED.4020000@codeaurora.org>
References: <CA+icZUV7R5hqTupiuZZKWcsZ5LOBGmY6xgmMTM7W3ojJo0Sp4w@mail.gmail.com>
	<20110728160136.771e2c0a.rdunlap@xenotime.net>
	<CA+icZUXLpThpEem+DPimemYVHqSKb5NAb5h_L-rMPWsD+WJTYg@mail.gmail.com>
	<20110728220926.6d1a91f4.rdunlap@xenotime.net>
	<CA+icZUVsJNSDzBvvH810POEydpaZxJZfM8J9bD+93+4d+88D_A@mail.gmail.com>
	<CA+icZUX=qM+xhJkteXs=F_RJP+k-Tzf3+Cp4ZdeatZ0cgHegBw@mail.gmail.com>
	<4E32F2ED.4020000@codeaurora.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 10:50:37 -0700 Stephen Boyd wrote:

> On 07/29/2011 02:45 AM, Sedat Dilek wrote:
> > [ CCing all people from 0416 patch ]
> >
> > OK, here a quick review and looking for suspicious commits:
> [snip]
> > -- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
> >          proportions.o prio_heap.o ratelimit.o show_mem.o \
> >          is_single_threaded.o plist.o decompress.o find_next_bit.o
> >
> > +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >  lib-$(CONFIG_MMU) += ioremap.o
> >  lib-$(CONFIG_SMP) += cpumask.o
> >
> > So, I can rebuild next-201107{27,28} with
> > CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y and look again if the
> > build-breakage in binfmt_misc is gone.
> >
> > Any comments from x86 folk?
> 
> I already noticed this and sent a fixup patch to Andrew. Looks like he
> never picked it up. The real fix is to change that lib-$(CONFIG... to
> obj-$(CONFIG...
> 
> See https://lkml.org/lkml/2011/7/6/6 for the patch.

Thanks, that works.

Adding Andrew to cc list.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
