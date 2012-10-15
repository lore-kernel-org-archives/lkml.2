Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2JOUot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:44:49 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:35469 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2JOUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:44:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd/DA9055: Remove Unicode Byte Order Marks
Date: Mon, 15 Oct 2012 22:44:45 +0200
Message-Id: <1350333885-20323-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older gcc (< 4.4) doesn't like files starting with Unicode BOMs:

include/linux/mfd/da9055/core.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/core.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/core.h:1: error: stray ‘\277’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\277’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\277’ in program

Remove the BOMs, the rest of the files is plain ASCII anyway.

Output of "file" before:

include/linux/mfd/da9055/core.h:  UTF-8 Unicode (with BOM) C program text
include/linux/mfd/da9055/pdata.h: UTF-8 Unicode (with BOM) C program text
include/linux/mfd/da9055/reg.h:   UTF-8 Unicode (with BOM) C program text

Output of "file" after:

include/linux/mfd/da9055/core.h:  ASCII C program text
include/linux/mfd/da9055/pdata.h: ASCII C program text
include/linux/mfd/da9055/reg.h:   ASCII C program text

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/mfd/da9055/core.h  |    2 +-
 include/linux/mfd/da9055/pdata.h |    2 +-
 include/linux/mfd/da9055/reg.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/da9055/core.h b/include/linux/mfd/da9055/core.h
index c96ad68..956afa4 100644
--- a/include/linux/mfd/da9055/core.h
+++ b/include/linux/mfd/da9055/core.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * da9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
diff --git a/include/linux/mfd/da9055/pdata.h b/include/linux/mfd/da9055/pdata.h
index 147293b..b9b204e 100644
--- a/include/linux/mfd/da9055/pdata.h
+++ b/include/linux/mfd/da9055/pdata.h
@@ -1,4 +1,4 @@
-﻿/* Copyright (C) 2012 Dialog Semiconductor Ltd.
+/* Copyright (C) 2012 Dialog Semiconductor Ltd.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/linux/mfd/da9055/reg.h b/include/linux/mfd/da9055/reg.h
index df237ee..2b592e0 100644
--- a/include/linux/mfd/da9055/reg.h
+++ b/include/linux/mfd/da9055/reg.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * DA9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
-- 
1.7.0.4

