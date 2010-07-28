Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0G1DG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:06:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44811 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0G1DG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mMYXFO1yh5q+jFbq46ZqDOa6M9O/oucB9nCwkYAV+vVOZgQ5AyNRrLQKjmL/8myyV1
         cidvAy5Iuc+OkhtxGHFQM+1RDRKKBbVq/ldN+ob9ZRp01q4ZdDx8L8LjAePkpOkVy236
         2yibLcs0qkiHaxkXdqqDop4bpo+ADRPYEVroQ=
Subject: [PATCH 2/2] s6e63m0: fix section mismatch
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        InKi Dae <inki.dae@samsung.com>
Content-Type: text/plain
Date: Wed, 28 Jul 2010 11:07:36 +0800
Message-Id: <1280286456.19065.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate section mismatch warning by marking s6e63m0_probe() as __devinit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/s6e63m0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index b27ccf9..1757379 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -732,7 +732,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
 static DEVICE_ATTR(gamma_table, 0644,
 		s6e63m0_sysfs_show_gamma_table, NULL);
 
-static int __init s6e63m0_probe(struct spi_device *spi)
+static int __devinit s6e63m0_probe(struct spi_device *spi)
 {
 	int ret = 0;
 	struct s6e63m0 *lcd = NULL;
-- 
1.5.4.3



