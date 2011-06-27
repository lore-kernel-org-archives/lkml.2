Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1F0Hre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:47:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab1F0HqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:46:19 -0400
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of
 arbitrary physical addresses
From: Petr Tesarik <ptesarik@suse.cz>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <BANLkTi=MeNcOhxU2TYvaC+xwebxcROnjcw@mail.gmail.com>
References: <201106171038.25988.ptesarik@suse.cz>
	 <20110617093032.GA19235@elte.hu> <201106171155.32062.ptesarik@suse.cz>
	 <BANLkTi=MeNcOhxU2TYvaC+xwebxcROnjcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 27 Jun 2011 09:46:12 +0200
Message-Id: <1309160772.7689.9.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang píše v Po 20. 06. 2011 v 10:42 +0800:
> On Fri, Jun 17, 2011 at 5:55 PM, Petr Tesarik <ptesarik@suse.cz> wrote:
> > Dne Pá 17. června 2011 11:30:32 Ingo Molnar napsal(a):
> >> * Petr Tesarik <ptesarik@suse.cz> wrote:
> >> > This patch series enhances /dev/mem, so that read and write is
> >> > possible at any address. The patchset includes actual
> >> > implementation for x86.
> >>
> >> This series lacks a description of why this is desired.
> >
> > Hi Ingo,
> >
> >> My strong opinion is that it's not desired at all: /dev/mem never
> >> worked beyond 4G addresses so by today it has become largely obsolete
> >> and is on the way out really.
> >>
> >> I'm aware of these current /dev/mem uses:
> >>
> >>  - Xorg maps below 4G non-RAM addresses and the video BIOS
> >>
> >>  - It used to have some debugging role but these days kexec and kgdb
> >>    has largely taken over that role - partly due to the 4G limit.
> >
> > It is still used as a "memory source" by Dave Anderson's crash utility for
> > live examination of a running system. Redhat has "overcome" the /dev/mem
> > deficiencies by writing an out-of-tree re-implementation of /dev/mem, which
> > uses /dev/crash instead. As it is an "unnecessary duplication of an existing
> > driver", this method was rejected by the project manager here at SUSE.
> >
> > The suggested alternative was to enhance (or fix) the existing driver. Without
> > this patch series there is no way to access high memory. In conjunction with
> > CONFIG_HIGHPTE, it makes the crash utility near to useless on anything with
> > high memory, because crash can no longer translate virtual to physical
> > addresses.
> >
> 
> How about /proc/kcore? AFAIK, it can access highmem, but Dave didn't consider
> it for some reason.

(Sorry for the dealy, I was on vacation.)

/proc/kcore is in fact supported by the crash utility and it does work
with highmem to some extent. Unfortunately, it cannot handle all of it,
because it is ELF32 format, so there's no way to describe regions beyond
4GB.

Petr Tesarik

