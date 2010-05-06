Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab0EFLCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:02:54 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49000 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0EFLCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:02:52 -0400
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 07:02:52 EDT
From: "Oskar Schirmer" <os@emlix.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>
Subject: [PATCH] ad7877: fix spi word size to 16 bit
Date: Thu,  6 May 2010 12:37:44 +0200
Message-Id: <1273142265-11929-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With no word size given in the users platform data,
a generic spi host controller driver will assume a default
word size of eight bit. This causes transmission to be
performed bytewise, which will fail on little endian
machines for sure. Failure on big endian depends on usage
of slave select to mark word boundaries.

Anyway, ad7877 is specified to work with 16 bit per word,
so unconditionally set the word size accordingly.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oliver Schneidewind <osw@emlix.com>
---
 drivers/input/touchscreen/ad7877.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index e019d53..92acd85 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -669,6 +669,8 @@ static int __devinit ad7877_probe(struct spi_device *spi)
 		dev_dbg(&spi->dev, "SPI CLK %d Hz?\n",spi->max_speed_hz);
 		return -EINVAL;
 	}
+	spi->bits_per_word = 16;
+	spi_setup(spi);
 
 	ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
 	input_dev = input_allocate_device();
-- 
1.5.3.7

