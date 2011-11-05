Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KEBx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:53:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8614 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1KEBxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:53:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization:x-system-of-record;
	b=tCaRgqYn8x7UKw3Tu1qtHffWyW0PzKVUll1HlsKauDfvIisxWBAuTaIq5oPGi+W+W
	uJH31uIj/NiMeNZYJt1Hg==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v3 0/9] forcedeth: minor fixes for stats, rmmod, sparse
Date: Fri,  4 Nov 2011 18:53:24 -0700
Message-Id: <cover.1320457247.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
 - removed "Fix a race during rmmod of forcedeth" from the series
   (will look at it separately with original author)
 - added "remove unneeded stats updates" and "64-bit stats"
 - reordered patches

Changes since v1:
 - rebased on top of netdev tip
 - do not repeat name of device in netdev_dbg
 - do not completely mute TX timeout messages when debug_tx_timeout is
   not set
 - make debug_tx_timeout writable in /sys/module
 Note: I am re-submitting "expose module parameters in /sys/module" as
       it can be useful in production and I was assured it doesn't add
       much memory overhead by the sysfs maintainers.

Tested:
  16-way x86_64 SMP, dual forcedeth ->
  RX bytes:7244556582 (7.2 GB)  TX bytes:181904254 (181.9 MB)


############################################
# Patch Set Summary:

David Decotigny (4):
  forcedeth: expose module parameters in /sys/module
  forcedeth: remove unneeded stats updates
  forcedeth: 64-bit stats
  forcedeth: fix a few sparse warnings (variable shadowing)

Mandeep Baines (1):
  forcedeth: Improve stats counters

Mike Ditto (2):
  forcedeth: Add messages to indicate using MSI or MSI-X
  forcedeth: Acknowledge only interrupts that are being processed

Sameer Nanda (2):
  forcedeth: allow to silence tx_timeout debug messages
  forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts

 drivers/net/ethernet/nvidia/forcedeth.c |  269 ++++++++++++++++---------------
 1 files changed, 142 insertions(+), 127 deletions(-)

-- 
1.7.3.1

