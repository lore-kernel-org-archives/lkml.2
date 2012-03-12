Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2CLUOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:14:22 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58952
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756980Ab2CLUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:14:20 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH 0/2] net/hyperv: Add support for vlan trunking from guests
Date: Mon, 12 Mar 2012 13:20:48 -0700
Message-Id: <1331583650-29686-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add vlan trunking feature from guests. With this feature,
a Linux guest can now configure multiple vlans through a single synthetic
NIC on Win8 Hyper-V host.

Note: Both patches should go to the 'net-next' tree. The patch [1/2] is
required by the vlan trunking feature [2/2]. So they should go together.

The bug in rndis_filter_receive() does NOT happen until we start to use 
'per-packet-data' by the vlan trunking feature, so the bug fix [1/2] isn't
urgent to be applied into 'net' tree.


Haiyang Zhang (2):
  net/hyperv: Fix data corruption in rndis_filter_receive()
  net/hyperv: Add support for vlan trunking from guests

 drivers/net/hyperv/hyperv_net.h   |   34 +++++++++++++-
 drivers/net/hyperv/netvsc.c       |    3 +-
 drivers/net/hyperv/netvsc_drv.c   |    8 ++-
 drivers/net/hyperv/rndis_filter.c |   93 +++++++++++++++++++++++++++----------
 4 files changed, 110 insertions(+), 28 deletions(-)

-- 
1.7.4.1

