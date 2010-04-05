Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0DEClQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 22:41:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab0DEClJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 22:41:09 -0400
Message-ID: <4BB94DC1.5010403@kernel.org>
Date: Mon, 05 Apr 2010 11:41:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Yong Wang <yong.y.wang@intel.com>
Subject: [PATCH] eeepc-wmi: include slab.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Apr 2010 02:41:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc-wmi uses kfree() but doesn't include slab.h.  Include it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yong Wang <yong.y.wang@intel.com>
---
Hello,

I've committed this patch to percpu#slabh branch which breaks implicit
slab interface availability.  I'm gonna push the branch to Linus
soonish.

Thanks.

 drivers/platform/x86/eeepc-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 2466b7b..9f88226 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 #include <acpi/acpi_bus.h>
-- 
1.6.4.2

