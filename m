Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1F3VG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:06:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48362 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1F3VG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:06:56 -0400
Date: Thu, 30 Jun 2011 18:07:17 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-06-30
Message-ID: <20110630210717.GD25602@joana>
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

A lot of new code, a lot of new bugs. This pull request has really important
fixes for 3.0. There are here two regression fixes, a hidp deadlock hang up
of the system fix from Peter Hurley. As the commit messages says it is a
partial revert from a commit that adds kthread to hidp. And L2CAP incoming
connection request fix that was breaking one test in the PTS suit,
that is, breaking interop. Patch is based on code from Ilia Kolomisnky.
Also, a buffer overflow fix by Dan Rosenberg and finally Tomas Targownik fixed
a memory leak on failed connections attempts that seems to be around since
2006!!

Please pull, or let me know any concerns you have.

	Gustavo

The following changes since commit fa7ccfb17033bfb5bca86f6b909cab0b807efbc0:

  rtlwifi: rtl8192se: Handle duplicate PCI ID 0x10ec:0x8192 conflict with r8192e_pci (2011-06-20 14:56:56 -0400)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Dan Rosenberg (1):
      Bluetooth: Prevent buffer overflow in l2cap config request

Gustavo F. Padovan (1):
      Bluetooth: Fix regression with incoming L2CAP connections

Peter Hurley (1):
      Bluetooth: Fix hidp disconnect deadlocks and lost wakeup

Tomas Targownik (1):
      Bluetooth: Fix memory leak under page timeouts

 net/bluetooth/hci_conn.c   |    3 +++
 net/bluetooth/hidp/core.c  |   18 +++++++++++-------
 net/bluetooth/hidp/hidp.h  |    1 +
 net/bluetooth/l2cap_core.c |    5 +++--
 4 files changed, 18 insertions(+), 9 deletions(-)

