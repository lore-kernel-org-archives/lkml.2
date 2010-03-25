Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0CYSbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:31:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32642 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0CYSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:31:00 -0400
Message-ID: <4BABAB71.3010402@oracle.com>
Date: Thu, 25 Mar 2010 11:29:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Subject: [PATCH 1/3 -next] drm: fix build error when SYSRQ is disabled
References: <20100325173853.f06a7b33.sfr@canb.auug.org.au>
In-Reply-To: <20100325173853.f06a7b33.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BABABC9.0185:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:

drivers/gpu/drm/drm_fb_helper.c:915: error: 'sysrq_drm_fb_helper_restore_op' undeclared (first use in this function)
drivers/gpu/drm/drm_fb_helper.c:929: error: 'sysrq_drm_fb_helper_restore_op' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20100325.orig/drivers/gpu/drm/drm_fb_helper.c
+++ linux-next-20100325/drivers/gpu/drm/drm_fb_helper.c
@@ -283,6 +283,8 @@ static struct sysrq_key_op sysrq_drm_fb_
 	.help_msg = "force-fb(V)",
 	.action_msg = "Restore framebuffer console",
 };
+#else
+static struct sysrq_key_op sysrq_drm_fb_helper_restore_op = { };
 #endif
 
 static void drm_fb_helper_on(struct fb_info *info)
