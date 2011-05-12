Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1ELRLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:25 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38043 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1ELRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SQ3bkmDqJ9vnyOW/pFq4D7XVymCbt3TcC18U2nNvzHkphRvWunWmFnfQ5bDFv5zjiA
         nUHsnANVQPyoRpBuqxp6T5oO3V6jMkF9NLVanLDPoSt4NznMK9LbR9IMP0Mzlt2jJfNP
         fSpzESRsTQ2QX0JP3vqk2NT0V0W3gStJjcqR8=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 1/4] export bus_kset
Date: Thu, 12 May 2011 19:11:02 +0200
Message-Id: <1305220265-9020-2-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/base/bus.c      |    3 ++-
 include/linux/kobject.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 000e7b2..2134248 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -158,7 +158,8 @@ static const struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
-static struct kset *bus_kset;
+struct kset *bus_kset;
+EXPORT_SYMBOL(bus_kset);
 
 
 #ifdef CONFIG_HOTPLUG
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 8f6d121..456b20d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -205,6 +205,8 @@ extern struct kobject *power_kobj;
 /* The global /sys/firmware/ kobject for people to chain off of */
 extern struct kobject *firmware_kobj;
 
+extern struct kset *bus_kset ;
+
 #if defined(CONFIG_HOTPLUG)
 int kobject_uevent(struct kobject *kobj, enum kobject_action action);
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
-- 
1.7.0.4

