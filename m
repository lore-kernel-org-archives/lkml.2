Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2F0NzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:06 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:56108 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2F0NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/8 v3] i2c: i801: enable irq
Date: Wed, 27 Jun 2012 21:54:07 +0800
Message-Id: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 incoporates much review feedback from Jean Delvare.
I think I got most of the feedback in this version, but please double check!

The patchset is based on linus/master, and tested by me only on a Cougar Point
(Intel 6 Series PCH) SMBus controller, although Jean has tested earlier,
modified versions of these patches on ICH5, ICH7-M and ICH10.
This version should also work with no regressions on ICH3-M, even for interrupt
enabled SMBus byte-by-byte reads.

Note: The interrupt byte-by-byte patches have not yet been tested for SMBus
(not I2C) write transactions.  Testing help would be appreciated.

Daniel Kurtz (8):
  i2c: i801: refactor use of LAST_BYTE
    i801_block_transaction_byte_by_byte
  i2c: i801: optimize waiting for HWPEC to finish
  i2c: i801: check INTR after every transaction
  i2c: i801: check and return errors during byte-by-byte transfers
  i2c: i801: rename some SMBHSTCNT bit constants
  i2c: i801: drop ENABLE_INT9
  i2c: i801: enable irq for i801 smbus transactions
  i2c: i801: enable irq for byte_by_byte transactions

 drivers/i2c/busses/i2c-i801.c |  263 ++++++++++++++++++++++++++++++++---------
 1 files changed, 205 insertions(+), 58 deletions(-)

-- 
1.7.7.3
.
