Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2AUBMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:12:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40843 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2AUBMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:12:48 -0500
Date: Sat, 21 Jan 2012 01:12:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: sparc32 vs lib/mpi
Message-ID: <20120121011243.GC23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I realize that very few people care about sparc32 these days,
but...
	a) __clz_tab[] is defined (with identical contents) in
lib/mpi/mpi-bit.c and arch/sparc/lib/divdi3.S.  Linker is unhappy,
of course...
	b) the same thing ends up using __udiv_qrnnd(), which simply
does not exist on sparc32.  There's a Cthulhu-scaring cascade of
ifdefs in lib/mpi/longlong.h, with several variants of udiv_qrnnd()
for sparc.  Unfortunately, it falls back on use of __udiv_qrnnd()...
Note that arch/sparc/math-emu/sfp-util_32.h has a definition of
udiv_qrnnd() which might match one of inline assembly variants in
lib/mpi/longlong.h.  Or not.  BTW, what the hell is LONGLONG_STANDALONE?

	Could somebody who might remember still remember that stuff
come up with comments?  For now I'm disabling everything from
INTEGRITY_SIGNATURE down to MPILIB on sparc32 cross-build, but it
would be nice to get it at least somewhat sorted out...
