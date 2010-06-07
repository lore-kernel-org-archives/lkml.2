Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0FGL5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:57:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52659 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0FGL5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:57:42 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
Date: Mon, 7 Jun 2010 12:57:12 +0100
Message-ID: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
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
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 702709b..70bc796 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -567,7 +567,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#ifdef CONFIG_HOTPLUG
 	{
 		.procname	= "hotplug",
 		.data		= &uevent_helper,
-- 
1.7.1

