Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0CWRKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:10:52 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:44793 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0CWRKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:10:41 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] i2o: Remove the dangerous kobj_to_i2o_device macro
Date: Tue, 23 Mar 2010 18:10:40 +0100
Message-ID: <87aatz0xrj.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro worked only when applied to variables named 'kobj'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement by an inline function would be preferred.
However, nobody uses this macro, so it's simpler to just remove it.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 include/linux/i2o.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 87018dc..9e7a12d 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -782,7 +782,6 @@ extern int i2o_exec_lct_get(struct i2o_controller *);
 #define to_i2o_driver(drv) container_of(drv,struct i2o_driver, driver)
 #define to_i2o_device(dev) container_of(dev, struct i2o_device, device)
 #define to_i2o_controller(dev) container_of(dev, struct i2o_controller, device)
-#define kobj_to_i2o_device(kobj) to_i2o_device(container_of(kobj, struct device, kobj))
 
 /**
  *	i2o_out_to_virt - Turn an I2O message to a virtual address
-- 
1.5.6.5

