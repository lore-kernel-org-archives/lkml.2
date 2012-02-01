Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2BASLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:11:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:32954 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BASLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:11:33 -0500
Date: Wed, 01 Feb 2012 13:09:05 -0500 (EST)
Message-Id: <20120201.130905.1131458895704793597.davem@davemloft.net>
To: matz@suse.de
Cc: jkosina@suse.cz, torvalds@linux-foundation.org, walters@verbum.org,
        jack@suse.cz, linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>
	<alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz>
	<Pine.LNX.4.64.1202011818570.25409@wotan.suse.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 10:09:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Matz <matz@suse.de>
Date: Wed, 1 Feb 2012 18:41:05 +0100 (CET)

> One problem is that it's not a new problem, GCC emitted similar code since 
> about forever, and still they turned up only now (well, probably because 
> ia64 is dead, but sparc64 should have similar problems). 

Indeed, on sparc64 it does do the silly 64-bit access too:

wrong:
        ldx     [%o0+8], %g2
        sethi   %hi(2147483648), %g1
        or      %g2, %g1, %g1
        jmp     %o7+8
         stx    %g1, [%o0+8]

Personally I've avoided C bitfields like the plague in any code I've
written.
