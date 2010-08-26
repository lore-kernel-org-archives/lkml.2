Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0HaCN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:13:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53995 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0HaCN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Dx55OKrN3TCA9NNQpctDVB5bJE4w4GMk/ye5CSHVPjPdXWzcx6bkVps4azX8wYhv8F
         JnU3kfaZkO13chhlZkFNW7cNP21w1YhOykmUrOgSmVpPzhG+zmq3KLg0n9PnXOMvFSGH
         BGfHjaOEsdVVfdJwxn/ux/zlHrIWa5DIR3MKA=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH] ARM: pxa3xx: fix build error when CONFIG_MTD_PARTITIONS is not defined
Date: Thu, 26 Aug 2010 04:56:50 -0400
Message-Id: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MTD_PARTITIONS is not defined for pxa3xx NAND driver it will display a build error:

drivers/built-in.o: In function `pxa3xx_nand_remove':
drivers/mtd/nand/pxa3xx_nand.c:1367: undefined reference to `del_mtd_partitions'
drivers/built-in.o: In function `pxa3xx_nand_probe':
drivers/mtd/nand/pxa3xx_nand.c:1334: undefined reference to `add_mtd_partitions'
make: *** [.tmp_vmlinux1] Error 1

Patched against Eric Miao's pxa tree

Mark F. Brown (1):
  ARM: pxa3xx: fix build error when CONFIG_MTD_PARTITIONS is not
    defined

 drivers/mtd/nand/pxa3xx_nand.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

