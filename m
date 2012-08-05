Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2HEWM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:12:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59761 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2HEWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:12:54 -0400
From: =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net
Cc: amalysh@web.de, mhoffman@lightlink.com, ralf@linux-mips.org,
        manuel.lauss@googlemail.com, axel.lin@gmail.com, olof@lixom.net,
        rusty@rustcorp.com.au, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
Subject: [PATCH 0/2] I2C: SIS630: Add SIS964 support 
Date: Mon,  6 Aug 2012 00:11:52 +0200
Message-Id: <1344204714-16513-1-git-send-email-amaury.decreme@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20120805140454.3e7a9606@endymion.delvare>
References: <20120805140454.3e7a9606@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add SIS964 support to i2c-sis630.

The SIS964 is very similar to SIS630 for the SMBus.
	+------------------------+--------------------+-------------------+
	|                        |     SIS630/730     |      SIS964       |
	+------------------------+--------------------+-------------------+
	| Clock                  | 14kHz/56kHz        | 55.56kHz/27.78kHz |
	| SMBus registers offset | 0x80               | 0xE0              |
	| SMB_CNT                | Bit 1 = Slave Busy | Bit 1 = Bus probe |
	| SMB_COUNT              | 4:0 bits           | 5:0 bits          |
	+------------------------+--------------------+-------------------+

The other differences doesn't affect the functions provided by the original
driver.

The SIS964 name is ambiguous as this chip isn't part of the SIS96X family and
behaves differently.

Done with SiS 630 and 964 datasheets.

Amaury Decrême (2):
  I2C: SIS630: Add SiS964 support
  I2C: SIS630: Cosmetics

 Documentation/i2c/busses/i2c-sis630 |   17 +-
 drivers/i2c/busses/Kconfig          |    4 +-
 drivers/i2c/busses/i2c-sis630.c     |  445 +++++++++++++++++++++--------------
 3 files changed, 278 insertions(+), 188 deletions(-)

-- 
1.7.8.6

