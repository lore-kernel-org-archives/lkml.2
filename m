Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2DQBYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:24:35 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:53671 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2DQBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:24:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1334625872!3266032!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base/bus.c: local variables should not be exposed globally
Date: Mon, 16 Apr 2012 18:14:10 -0700
User-Agent: KMail/1.9.9
CC: <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161814.11066.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'system_kset' is only referenced in this file and
should be marked static to prevent it from being exposed globally.

This quiets the sparse waring:

warning: symbol 'system_kset' was not declared. Should it be static?

Also, remove the comment since drivers/base/sys.c has now been
deleted.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 26a06b8..2bcef65 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -21,8 +21,7 @@
 #include "power/power.h"
 
 /* /sys/devices/system */
-/* FIXME: make static after drivers/base/sys.c is deleted */
-struct kset *system_kset;
+static struct kset *system_kset;
 
 #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
 
