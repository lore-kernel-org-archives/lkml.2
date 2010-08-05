Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620Ab0HEWiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:38:17 -0400
Received: from kroah.org ([198.145.64.141]:37701 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760849Ab0HEWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:24 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/28] hotplug: Support kernel/hotplug sysctl variable when !CONFIG_NET
Date: Thu,  5 Aug 2010 15:23:54 -0700
Message-Id: <1281047058-23716-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
made conditional on CONFIG_NET by commit
f743ca5e10f4145e0b3e6d11b9b46171e16af7ce (applied in 2.6.18) to fix
problems with undefined references in 2.6.16 when CONFIG_HOTPLUG=y &&
!CONFIG_NET, but this restriction is no longer needed.

This patch makes the kernel/hotplug sysctl variable depend only on
CONFIG_HOTPLUG.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Randy Dunlap <randy.dunlap@oracle.COM>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d24f761..f73da1c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -562,7 +562,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#ifdef CONFIG_HOTPLUG
 	{
 		.procname	= "hotplug",
 		.data		= &uevent_helper,
-- 
1.7.2

