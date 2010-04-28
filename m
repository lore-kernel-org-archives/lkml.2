Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0D1P2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:28:24 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59790 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0D1P2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:28:22 -0400
Date: Wed, 28 Apr 2010 16:28:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Fritzsche <peter.fritzsche@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] asm-generic: Don't warn that atomic_t is only 24 bit
Message-ID: <20100428152815.GB25569@shareable.org>
References: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de> <1272453036-18670-1-git-send-email-peter.fritzsche@gmx.de> <201004281533.29327.arnd@arndb.de> <20100428135434.GA4662@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428135434.GA4662@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Arnd Bergmann (arnd@arndb.de) wrote:
> > On Wednesday 28 April 2010, Peter Fritzsche wrote:
> > > 32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
> > > This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
> > > implementation to use the parisc approach of having an array of
> > > spinlocks to protect the atomic_t.
> > > 
> > > These warnings were also removed from the sparc implementation when the
> > > new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
> > > but the warning still remained in some other places without any
> > > 24-bit-only atomic_t implementation inside the kernel.
> > > 
> > > We should remove these warnings to allow users to rely on the full
> > > 32-bit range of atomic_t.
> > > 
> > > Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> AFAIK that was the last architecture imposing limitations below 32 bits
> on atomic_t.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

If the comment's getting removed, it should probably go from here too:

linux-2.6$ git grep '24' arch/*/include/*/atomic*
arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is only 24 bits
arch/mn10300/include/asm/atomic.h: * useful range of an atomic_t is only 24 bits
arch/mn10300/include/asm/atomic.h: * Note that the guaranteed useful range of an
arch/mn10300/include/asm/atomic.h: * Note that the guaranteed useful range of an

-- Jamie
