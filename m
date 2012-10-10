Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2JJEvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:51:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35733 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2JJEve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:51:34 -0400
Date: Wed, 10 Oct 2012 05:51:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121010045126.GB2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <50747F80.4060503@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50747F80.4060503@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:48:16PM -0400, Chris Metcalf wrote:
> On 10/1/2012 5:38 PM, Al Viro wrote:
> > 	There's an interesting ongoing project around kernel_thread() and
> > friends, including execve() variants.  I really need help from architecture
> > maintainers on that one; I'd been able to handle (and test) quite a few
> > architectures on my own [alpha, arm, m68k, powerpc, s390, sparc, x86, um]
> > plus two more untested [frv, mn10300].  c6x patches had been supplied by
> > Mark Salter; everything else remains to be done.  Right now it's at
> > minus 1.2KLoC, quite a bit of that removed from asm glue and other black
> > magic.
> 
> I'll take a look at this for arch/tile this week.

Thanks.  FWIW, changes since the last posting:
	* untested conversion for cris added [me]
	* conversion for mips added [Ralf has done execve side, I've added
kernel_thread() one]
	* conversion for parisc added [aka "Al has generated broken patches,
jejb has tested and fixed that crap"]
	* arm64 conversion added [Catalin Marinas]

IOW, right now we have
	* alpha, arm, arm64, c6x, m68k, mips, parisc, powerpc, s390, sparc,
um, x86 - apparently over and done with (IOW, all old architectures except for
itanic are converted by now)
	* avr32, blackfin, hexagon, h8300, ia64, m32r, microblaze, openrisc,
score, sh, tile, unicore32, xtensa - need to be done
	* cris, frv, mn10300 - need to be tested (and very likely will need
fixing)
