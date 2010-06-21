Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0FVAEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:04:32 -0400
Received: from mail.pxnet.com ([89.1.7.7]:38335 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab0FVAEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:04:30 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 20:04:29 EDT
Subject: [PATCH 0/5] late Gigaset fixes for 2.6.35
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20100622-patch-gigaset-00.tilman@imap.cc>
Date: Tue, 22 Jun 2010 01:54:04 +0200 (CEST)
X-Spam-Score: -2.009 () AWL,BAYES_00,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten, David,

following are five patches to the Gigaset driver fixing reported
problems with two CAPI applications (Asterisk and capifax). They
fix serious bugs, though not technically regressions, and I would
therefore appreciate if they could still make it into release
2.6.35. Otherwise please queue them for the first stable cycle.

These should also go into 2.6.34-stable. They apply cleanly to
2.6.34 except for some offsets in file drivers/isdn/gigaset/capi.c.

I'll follow up with a series of less urgent patches which I'll
propose for eventual inclusion in release 2.6.36.

Thanks,
Tilman

Tilman Schmidt (5):
      isdn/gigaset: honor CAPI application's buffer size request
      isdn/gigaset: correct CAPI voice connection encoding
      isdn/gigaset: correct CAPI DATA_B3 Delivery Confirmation
      isdn/gigaset: encode HLC and BC together
      isdn/gigaset: correct CAPI connection state storage

 drivers/isdn/gigaset/asyncdata.c |   44 +---
 drivers/isdn/gigaset/capi.c      |  407 ++++++++++++++++++++++++++-----------
 drivers/isdn/gigaset/common.c    |   36 ++---
 drivers/isdn/gigaset/ev-layer.c  |    4 +-
 drivers/isdn/gigaset/gigaset.h   |   38 +++--
 drivers/isdn/gigaset/i4l.c       |   21 ++
 drivers/isdn/gigaset/isocdata.c  |   72 +++-----
 7 files changed, 382 insertions(+), 240 deletions(-)

