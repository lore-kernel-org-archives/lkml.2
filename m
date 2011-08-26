Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1HZTMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 15:12:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48080 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705Ab1HZTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 15:12:23 -0400
X-Sasl-enc: 5gk1M195HPXNEW3ETN4sl2Li/C6wlfgIn69qv9TuGGCY 1314385942
Date: Fri, 26 Aug 2011 12:11:30 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 3.1
Message-ID: <20110826191130.GA5557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some driver core, and other driver-core related fixes for your
3.1 git tree.

Just a few minor fixes for things that people have reported, and a
number of bug fixes for the ti-st driver.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/ driver-core-linus

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/base/devres.c          |    1 +
 drivers/base/devtmpfs.c        |    2 +-
 drivers/base/platform.c        |    2 +-
 drivers/firmware/google/gsmi.c |    2 +-
 drivers/misc/Kconfig           |    1 +
 drivers/misc/ti-st/st_core.c   |   10 +++++++++-
 drivers/misc/ti-st/st_kim.c    |   33 +++++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_ll.c     |   19 +++++++++++++++++++
 include/linux/ti_wilink_st.h   |   27 ++++++++++++++++++++++++++-
 9 files changed, 92 insertions(+), 5 deletions(-)

---------------

Arnaud Lacombe (1):
      drivers/base/devtmpfs.c: correct annotation of `setup_done'

H Hartley Sweeten (1):
      base/devres.c: quiet sparse noise about context imbalance

Heiko Carstens (1):
      pti: add missing CONFIG_PCI dependency

Pavan Savoy (7):
      drivers:misc: ti-st: avoid a misleading dbg msg
      drivers:misc:ti-st: platform hooks for chip states
      drivers:misc: ti-st: reinit completion on ver read
      drivers:misc: ti-st: reinit completion before send
      drivers:misc: ti-st: wait for completion at fail
      drivers:misc: ti-st: free skb on firmware download
      drivers:misc: ti-st: fix unexpected UART close

Randy Dunlap (2):
      firmware: fix google/gsmi.c build warning
      driver core: fix kernel-doc warning in platform.c

Vijay Badawadagi (1):
      drivers:misc: ti-st: fail-safe on wrong pkt type

