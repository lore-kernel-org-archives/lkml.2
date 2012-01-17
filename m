Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2AQIOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:14:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52374 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2AQIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:14:15 -0500
From: Minchan Kim <minchan@kernel.org>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org,
        Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/3] low memory notify
Date: Tue, 17 Jan 2012 17:13:55 +0900
Message-Id: <1326788038-29141-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you can see, it's respin of mem_notify core of KOSAKI and Marcelo.
(Of course, KOSAKI's original patchset includes more logics but I didn't
include all things intentionally because I want to start from beginning
again) Recently, there are some requirements of notification of system
memory pressure. It would be very useful for various cases.
For example, QEMU/JVM/Firefox like big memory hogger can release their memory
when memory pressure happens. Another example in embedded side,
they can close background application. For this, there are some trial but
we need more general one and not-hacked alloc/free hot path.

I think most big problem of system slowness is swap-in operation.
Swap-in is a synchronous operation so application's latency would be 
big. Solution for that is prevent swap-out itself. We couldn't prevent
swapout totally but could reduce it with this patch.

In case of swapless system, code page is very important for system response.
So we have to keep code page, too. I used very naive heuristic in this patch
but welcome to any idea.

I want to make kernel logic simple if possible and just notify to user space.
Of course, there are lots of thing we have to consider but for discussion
this simple patch would be a good start point.

This version is totally RFC so any comments are welcome.

Minchan Kim (3):
  [RFC 1/3] /dev/low_mem_notify
  [RFC 2/3] vmscan hook
  [RFC 3/3] test program

 drivers/char/mem.c             |    7 ++
 include/linux/low_mem_notify.h |    6 ++
 mm/Kconfig                     |    7 ++
 mm/Makefile                    |    1 +
 mm/low_mem_notify.c            |   61 ++++++++++++++++++++
 mm/vmscan.c                    |   28 +++++++++
 poll.c                         |  121 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 231 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/low_mem_notify.h
 create mode 100644 mm/low_mem_notify.c
 create mode 100644 poll.c

-- 
1.7.7.5

