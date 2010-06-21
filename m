Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab0FUSGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:06:04 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44064 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0FUSGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:00 -0400
Date: Mon, 21 Jun 2010 13:05:16 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       akpm@linux-foundation.org
Subject: Re: 2.6.35-rc3 deadlocks on wakeup(?) (was on semaphore
 operations)
In-Reply-To: <alpine.DEB.2.00.1006211209520.7407@router.home>
Message-ID: <alpine.DEB.2.00.1006211253160.7407@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <4C1CA49B.7020104@colorfullife.com> <alpine.DEB.2.00.1006211155540.7407@router.home> <alpine.DEB.2.00.1006211209520.7407@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same thing happens with fakeroot-tcp. So it looks like it is not the
semaphore ops but the wakeup logic.

In one case processes wer waiting in sk_wait??  or so and one sees

libfakeroot: read: Connection timed out

after awhile. Wereupon the build continues for a while until it hangs for
good.

Another run resulted in hangs during futex wait:

$ strace -p8015
Process 8015 attached - interrupt to quit
futex(0x2b6bd51d0640, FUTEX_WAIT_PRIVATE, 2, NULL

There are always some zombies around when this occurs.

0  1000  8015  7712  20   0  18632  6796 futex_ S+   pts/0      0:00 /usr/bin/make -f scripts/Makefile.build obj=drivers/net
0  1000  8239  8015  20   0      0     0 exit   Z+   pts/0      0:00 [make] <defunct>
0  1000  8240  8015  20   0      0     0 exit   Z+   pts/0      0:00 [make] <defunct>
0  1000  8251  8015  20   0      0     0 exit   Z+   pts/0      0:00 [make] <defunct>






