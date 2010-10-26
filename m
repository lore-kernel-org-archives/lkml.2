Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab0JZPti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:49:38 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54496 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759965Ab0JZPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:49:36 -0400
Date: Tue, 26 Oct 2010 17:47:52 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Ralph Campbell <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband/ipath: don't reset disabled devices
Message-ID: <20101026174752.0f7f28dd@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment some lines above states that disabled devices
must not reset.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/infiniband/hw/ipath/ipath_sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/infiniband/hw/ipath/ipath_sysfs.c
index b8cb2f1..8991677 100644
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ b/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -557,6 +557,7 @@ static ssize_t store_reset(struct device *dev,
 		dev_info(dev,"Unit %d is disabled, can't reset\n",
 			 dd->ipath_unit);
 		ret = -EINVAL;
+		goto bail;
 	}
 	ret = ipath_reset_device(dd->ipath_unit);
 bail:
-- 
1.7.2.2
