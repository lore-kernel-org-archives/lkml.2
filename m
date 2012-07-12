Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2GLEcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:32:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10176 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2GLEci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:32:38 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-2b-4ffe5364d52c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] extcon: Remove CONFIG_EXTCON_MODULE config to fix build break
Date: Thu, 12 Jul 2012 13:32:27 +0900
Message-id: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd2U4H/+BlObtCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG4d2H2QuOcFScmX2JpYGxn72LkZNDQsBEYtvTPjYIW0ziwr31
	QDYXh5DAdEaJ4xveM0M4S5kkNq77zQJSxSagJbH/xQ2wDhEBOYknt/+AFTEL7GaUOP/1LzNI
	QljAT+LchMtgDSwCqhI3rjxmBLF5BVwkVr3bB7VaQaJ12SH2CYzcCxgZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEe/GZ9A7GVQ0WhxgFOBiVeHgl/P75C7EmlhVX5h5ilOBgVhLhNXIG
	CvGmJFZWpRblxxeV5qQWH2KU5mBREuc18f7qLySQnliSmp2aWpBaBJNl4uCUamDMnvzqQUfz
	mevuXaJ3qsJTfz5axr2us/lFWuKRhif9c67mLGs9WVp7gDduiVy2/uMdVqfXxcRNV9m8wKJo
	47IT09bePy9w+Xz4B/6b1Wr+pb9uXlZbPbNzAq9n9t5j8ab5AeJc7FlzPmWpKagvMDx8TlhT
	hs/nX06Z7Ttlh/grsww/XJaISHFVYinOSDTUYi4qTgQA+oms7N4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modify 'Kconfig' of EXTCON Subsystem to support either
active or inactive of EXTCON Subsystem. The various subsystem refer
to EXTCON subsystem for controlling external connector, so core class
of EXTCON should be included in kernel image. If EXTCON subsystem is
builded with MODULE, other subsystem have build break because of
linking the core class of EXTCON.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 29c5cf8..b0eac45 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -1,5 +1,5 @@
 menuconfig EXTCON
-	tristate "External Connector Class (extcon) support"
+	bool "External Connector Class (extcon) support"
 	help
 	  Say Y here to enable external connector class (extcon) support.
 	  This allows monitoring external connectors by userspace
-- 
1.7.0.4

