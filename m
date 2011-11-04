Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1KDBly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:41:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52549 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1KDBlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:41:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization:x-system-of-record;
	b=RnQqiXWZAqYCddiq5YP9gK6MitHHkjkOkQ7QVhLYSaAyqgre8CkCKeaj4ycJ2KVhH
	+tkp78kc2qvv3X9GNImhg==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v2 0/8] forcedeth: minor fixes for stats, rmmod, sparse
Date: Thu,  3 Nov 2011 18:41:15 -0700
Message-Id: <cover.1320369398.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the v2 of a forcedeth patch series I sent a few months
ago (... May).

Changes since v1:
 - rebased on top of netdev tip
 - do not repeat name of device in netdev_dbg
 - do not completely mute TX timeout messages when debug_tx_timeout is
   not set
 - make debug_tx_timeout writable in /sys/module

I am re-submitting "expose module parameters in /sys/module" as it can
be useful in production and I was assured it doesn't add much memory
overhead by the sysfs maintainers.

Tested:
  16-way x86_64 SMP, dual forcedeth


############################################
# Patch Set Summary:

David Decotigny (2):
  forcedeth: expose module parameters in /sys/module
  forcedeth: fix a few sparse warnings (variable shadowing)

Mandeep Baines (1):
  forcedeth: Improve stats counters

Mike Ditto (2):
  forcedeth: Acknowledge only interrupts that are being processed
  forcedeth: Add messages to indicate using MSI or MSI-X

Salman Qazi (1):
  forcedeth: Fix a race during rmmod of forcedeth

Sameer Nanda (2):
  forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts
  forcedeth: allow to silence tx_timeout debug messages

 drivers/net/ethernet/nvidia/forcedeth.c |  182 +++++++++++++++++++------------
 1 files changed, 110 insertions(+), 72 deletions(-)

-- 
1.7.3.1

