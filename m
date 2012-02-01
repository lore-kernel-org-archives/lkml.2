Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2BATEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:04:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44210 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2BATEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:04:34 -0500
Message-ID: <1328123041.4764.20.camel@otta>
Subject: Re: Memory corruption due to word sharing
From: Peter Bergner <bergner@vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: matz@suse.de, jkosina@suse.cz, torvalds@linux-foundation.org,
        walters@verbum.org, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Date: Wed, 01 Feb 2012 13:04:01 -0600
In-Reply-To: <20120201.130905.1131458895704793597.davem@davemloft.net>
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>
	 <alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz>
	 <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
	 <20120201.130905.1131458895704793597.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7182-0000-0000-000000A2DDCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 13:09 -0500, David Miller wrote:
> From: Michael Matz <matz@suse.de>
> Date: Wed, 1 Feb 2012 18:41:05 +0100 (CET)
> 
> > One problem is that it's not a new problem, GCC emitted similar code since 
> > about forever, and still they turned up only now (well, probably because 
> > ia64 is dead, but sparc64 should have similar problems). 
> 
> Indeed, on sparc64 it does do the silly 64-bit access too:
> 
> wrong:
>         ldx     [%o0+8], %g2
>         sethi   %hi(2147483648), %g1
>         or      %g2, %g1, %g1
>         jmp     %o7+8
>          stx    %g1, [%o0+8]

Ditto for powerpc64-linux:

        ld 9,8(3)
        li 10,1
        rldimi 9,10,31,32
        std 9,8(3)
        blr


Peter



