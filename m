Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2IVCLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 22:11:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54719 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2IVCLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 22:11:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, netdev@vger.kernel.org,
        JP Abgrall <jpa@google.com>, Ashish Sharma <ashishsharma@google.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH 0/7][RFC] Android netfilter patches
Date: Fri, 21 Sep 2012 22:10:46 -0400
Message-Id: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092202-7408-0000-0000-000008B477C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During Kernel Summit, I mentioned that one area of the Android patch
set that hasn't had seemed to have had much discussion were the
netfilter changes.

PJ Waskiewicz asked more about them, and I sent them along to him
to briefly review, and he suggested sending them out for wider review.

So here are some of the Android netfilter changes.

I'm not very familiar with the netfilter code, so I'm not proposing
these be merged, but I'm interested in hearing if folks have any
thoughts about the patches and what changes they thing might be
necessary in order for similar functionality to be included.

You can also access these patches via gitweb here:
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/netfilter


Cc: netdev@vger.kernel.org
Cc: JP Abgrall <jpa@google.com>
Cc: Ashish Sharma <ashishsharma@google.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>

Ashish Sharma (1):
  netfilter: xt_IDLETIMER: Rename INTERFACE to LABEL in netlink
    notification.

JP Abgrall (6):
  nf: xt_socket: export the fancy sock finder code
  netfilter: add xt_qtaguid matching module
  netfilter: qtaguid: initialize a local var to keep compiler happy.
  netfilter: xt_qtaguid: fix ipv6 protocol lookup
  netfilter: xt_qtaguid: start tracking iface rx/tx at low level
  netfilter: xt_IDLETIMER: Add new netlink msg type

 include/linux/netfilter/xt_IDLETIMER.h |    8 +
 include/linux/netfilter/xt_qtaguid.h   |   13 +
 include/linux/netfilter/xt_socket.h    |    6 +
 net/netfilter/Kconfig                  |   18 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_IDLETIMER.c           |   78 +-
 net/netfilter/xt_qtaguid.c             | 2966 ++++++++++++++++++++++++++++++++
 net/netfilter/xt_qtaguid_internal.h    |  333 ++++
 net/netfilter/xt_qtaguid_print.c       |  564 ++++++
 net/netfilter/xt_qtaguid_print.h       |  120 ++
 net/netfilter/xt_socket.c              |   69 +-
 11 files changed, 4146 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/netfilter/xt_qtaguid.h
 create mode 100644 net/netfilter/xt_qtaguid.c
 create mode 100644 net/netfilter/xt_qtaguid_internal.h
 create mode 100644 net/netfilter/xt_qtaguid_print.c
 create mode 100644 net/netfilter/xt_qtaguid_print.h

-- 
1.7.9.5

