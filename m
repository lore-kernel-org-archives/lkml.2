Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1G3Gdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:33:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43809 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1G3Gde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:33:34 -0400
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rientjes@google.com, hughd@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <m2pqksznea.fsf@firstfloor.org>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
	 <alpine.DEB.2.00.1107291002570.16178@router.home>
	 <m2pqksznea.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 08:33:28 +0200
Message-ID: <1312007608.2873.77.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 16:18 -0700, Andi Kleen a écrit :
> Christoph Lameter <cl@linux.com> writes:
> 
> > On Fri, 29 Jul 2011, Pekka Enberg wrote:
> >
> >> We haven't come up with a solution to keep struct page size the same but I
> >> think it's a reasonable trade-off.
> >
> > The change requires the page struct to be aligned to a double word
> > boundary. 
> 
> Why is that?
> 

Because cmpxchg16b is believed to require a 16bytes alignment.

http://siyobik.info/main/reference/instruction/CMPXCHG8B%2FCMPXCHG16B

64-Bit Mode Exceptions
...

#GP(0) 	If the memory address is in a non-canonical form. If memory
operand for CMPXCHG16B is not aligned on a 16-byte boundary. If
CPUID.01H:ECX.CMPXCHG16B[bit 13] = 0.



