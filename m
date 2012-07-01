Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2GARUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:20:36 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:33362 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2GARUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:20:35 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com,
        eric@eukrea.com
Subject: [PATCH 0/5] AT91SAM9G46/M11: add crypto drivers
Date: Sun,  1 Jul 2012 19:19:42 +0200
Message-Id: <1341163187-14946-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serie adds the support for the crypto engine available in
the Atmel SAM9G46 http://www.atmel.com/devices/SAM9G46.aspx and SAM9M11
http://www.atmel.com/devices/SAM9M11.aspx

For each driver the choice between PDC/DMA or PIO was optimized to
maximize the performances (benchmarks will soon be available on
the linux4sam wiki http://www.at91.com/).

These drivers were tested on both devices : the last patch adds a few
missing tests to tcrypt.

This work was sponsored by Atmel.

Nicolas Royer (5):
  ARM: AT91SAM9G45: add crypto peripherals
  crypto: add Atmel AES driver
  crypto: add Atmel DES/TDES driver
  crypto: add Atmel SHA1/SHA256 driver
  crypto: add new tests to tcrypt

 arch/arm/mach-at91/at91sam9g45.c              |   13 +-
 arch/arm/mach-at91/at91sam9g45_devices.c      |  128 +++
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    2 +
 crypto/tcrypt.c                               |   50 +-
 drivers/crypto/Kconfig                        |   47 +
 drivers/crypto/Makefile                       |    5 +-
 drivers/crypto/atmel-aes-regs.h               |   62 ++
 drivers/crypto/atmel-aes.c                    | 1206 ++++++++++++++++++++++++
 drivers/crypto/atmel-sha-regs.h               |   46 +
 drivers/crypto/atmel-sha.c                    | 1112 ++++++++++++++++++++++
 drivers/crypto/atmel-tdes-regs.h              |   89 ++
 drivers/crypto/atmel-tdes.c                   | 1215 +++++++++++++++++++++++++
 include/linux/platform_data/atmel-aes.h       |   22 +
 13 files changed, 3990 insertions(+), 7 deletions(-)
 create mode 100644 drivers/crypto/atmel-aes-regs.h
 create mode 100644 drivers/crypto/atmel-aes.c
 create mode 100644 drivers/crypto/atmel-sha-regs.h
 create mode 100644 drivers/crypto/atmel-sha.c
 create mode 100644 drivers/crypto/atmel-tdes-regs.h
 create mode 100644 drivers/crypto/atmel-tdes.c
 create mode 100644 include/linux/platform_data/atmel-aes.h

-- 
1.7.7.6

