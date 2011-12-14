Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1LNH4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:56:43 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57252 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab1LNH4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:56:40 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: khali@linux-fr.org, ben-linux@fluff.org, seth.heasley@intel.com,
        ben@decadent.org.uk, David.Woodhouse@intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, dlaurie@chromium.org, bleung@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/3] i2c: i801: enable irq
Date: Wed, 14 Dec 2011 15:56:29 +0800
Message-Id: <1323849392-20413-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches enables the Intel PCH SMBus controller interrupt.

The Interrupt can signify:
 INTR - the end of a complete transaction
 DEV_ERR - that a device did not ACK a transaction
 BYTE_DONE - the completion of a single byte during a byte-by-byte transaction

This patchset arrives with the following caveats:

 1)  It has only been tested with a Cougar Point (Intel 6 Series PCH) SMBus
controller, so the irq is only enabled for that chip type.

 2) It has not been tested with any devices that do transactions that use the
    PEC.  In fact, I believe that an additional small patch would be required
    to the driver working correctly in interrupt mode with PEC.

 3) It has not been tested in SMBus Slave mode.

 4) It has not been tested with SMI#-type interrupts.

 5) The BIOS has to configure the PCH SMBus IRQ properly.

 6) It has not been tested with a device that does byte-by-byte smbus (non-i2c)
    reads.

 7) It has not been tested with smbus 'process call' transactions.

If would be very helpful if somebody could help test on other chipsets, with
a PEC device, or on additional BIOS that woudl be very helpful.

In the meantime, the interrupt behavior is only enabled on the Cougar Point,
and even here, it can be completely disabled with the "Interrupt" feature like
other advanced features of the driver.

Daniel Kurtz (3):
  i2c: i801: refactor i801_block_transaction_byte_by_byte
  i2c: i801: enable irq for i801 smbus transactions
  i2c: i801: enable irq for byte_by_byte transactions

 drivers/i2c/busses/i2c-i801.c |  193 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 170 insertions(+), 23 deletions(-)

-- 
1.7.3.1

