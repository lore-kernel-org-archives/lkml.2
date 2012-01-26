Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2AZWCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:02:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35171 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2AZWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:02:07 -0500
Date: Thu, 26 Jan 2012 17:02:04 -0500 (EST)
Message-Id: <20120126.170204.2031178865806155061.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: Re: sparc32 vs lib/mpi
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120121011243.GC23916@ZenIV.linux.org.uk>
References: <20120121011243.GC23916@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 14:02:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 21 Jan 2012 01:12:43 +0000

> 	I realize that very few people care about sparc32 these days,
> but...
> 	a) __clz_tab[] is defined (with identical contents) in
> lib/mpi/mpi-bit.c and arch/sparc/lib/divdi3.S.  Linker is unhappy,
> of course...
> 	b) the same thing ends up using __udiv_qrnnd(), which simply
> does not exist on sparc32.  There's a Cthulhu-scaring cascade of
> ifdefs in lib/mpi/longlong.h, with several variants of udiv_qrnnd()
> for sparc.  Unfortunately, it falls back on use of __udiv_qrnnd()...
> Note that arch/sparc/math-emu/sfp-util_32.h has a definition of
> udiv_qrnnd() which might match one of inline assembly variants in
> lib/mpi/longlong.h.  Or not.  BTW, what the hell is LONGLONG_STANDALONE?
> 
> 	Could somebody who might remember still remember that stuff
> come up with comments?  For now I'm disabling everything from
> INTEGRITY_SIGNATURE down to MPILIB on sparc32 cross-build, but it
> would be nice to get it at least somewhat sorted out...

I'm taking a look at this.
