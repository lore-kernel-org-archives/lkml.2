Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1IVUrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:47:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62290 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1IVUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:47:08 -0400
Date: Thu, 22 Sep 2011 17:47:39 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-09-22
Message-ID: <20110922204739.GA2673@joana>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Here are a bunch of patches for 3.2. The biggest changes are for Bluetooth Low
Energy. The rest are mostly bugfixes and cleanups, except a simple
optimization on our scheduler and improvements to the Management Interface.

Please pull, or let me know any problems.

	Gustavo

The following changes since commit da3ba88a9996cd64c6768bed5727e02da81e2c8d:

  rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros. (2011-09-20 14:43:50 -0400)

are available in the git repository at:
  git://github.com/padovan/bluetooth-next.git master

Anderson Briglia (1):
      Bluetooth: Fix wrong memcpy size on LE start encryption

Andre Guedes (2):
      Bluetooth: Reduce critical region.
      Bluetooth: Check 'dev_class' in mgmt_device_found()

Antti Julku (2):
      Bluetooth: Add mgmt command for fast connectable mode
      Bluetooth: Add mgmt events for blacklisting

David Herrmann (1):
      Bluetooth: hidp: Add support for NO_INIT_REPORTS quirk

Luiz Augusto von Dentz (2):
      Bluetooth: make use of connection number to optimize the scheduler
      Bluetooth: mark l2cap_create_iframe_pdu as static

Peter Hurley (1):
      Bluetooth: Add LE link type for debugfs output

Vinicius Costa Gomes (15):
      Bluetooth: Reset the security timer when a command is queued
      Bluetooth: Add a flag to indicate that SMP is going on
      Bluetooth: Use the same timeouts for both ACL and LE links
      Bluetooth: Add support for pairing via mgmt over LE
      Bluetooth: Add support for running SMP without a socket
      Bluetooth: Add link_type information to the mgmt Connected event
      Bluetooth: Move SMP fields to a separate structure
      Bluetooth: Move SMP crypto functions to a workqueue
      Bluetooth: Require authentication if MITM protection is requested
      Bluetooth: Use the MEDIUM security level for pairings
      Bluetooth: Fix sending wrong authentication requirements
      Bluetooth: Use the LTK after receiving a LE Security Request
      Revert "Bluetooth: Add support for communicating keys with userspace"
      Bluetooth: Fix not setting a pending security level
      Bluetooth: Remove support for other SMP keys than the LTK

 include/net/bluetooth/hci.h      |   10 +
 include/net/bluetooth/hci_core.h |   25 ++-
 include/net/bluetooth/l2cap.h    |    8 +-
 include/net/bluetooth/mgmt.h     |   16 ++
 include/net/bluetooth/smp.h      |   17 ++
 net/bluetooth/hci_conn.c         |    2 +-
 net/bluetooth/hci_core.c         |   57 ++---
 net/bluetooth/hci_event.c        |   16 +-
 net/bluetooth/hci_sock.c         |   18 ++-
 net/bluetooth/hci_sysfs.c        |    2 +
 net/bluetooth/hidp/core.c        |    3 +
 net/bluetooth/l2cap_core.c       |   18 ++-
 net/bluetooth/mgmt.c             |  212 ++++++++++++++------
 net/bluetooth/smp.c              |  421 +++++++++++++++++++++++---------------
 14 files changed, 538 insertions(+), 287 deletions(-)

