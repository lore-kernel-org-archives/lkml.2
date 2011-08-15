Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1HOFIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:08:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33968 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1HOFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:59 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Rodolfo Giometti <giometti@enneenne.com>, linuxpps@ml.enneenne.com
Subject: [PATCH 07/11] drivers/pps: do not use EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:10 -0400
Message-Id: <1313384834-24433-8-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: linuxpps@ml.enneenne.com
---
 drivers/pps/generators/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/generators/Makefile b/drivers/pps/generators/Makefile
index 303304a..21e5e3b 100644
--- a/drivers/pps/generators/Makefile
+++ b/drivers/pps/generators/Makefile
@@ -4,6 +4,4 @@
 
 obj-$(CONFIG_PPS_GENERATOR_PARPORT) += pps_gen_parport.o
 
-ifeq ($(CONFIG_PPS_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_PPS_DEBUG) += -DDEBUG
-- 
1.7.6.153.g78432

