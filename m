Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0EFXq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:46:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63495 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0EFXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:46:57 -0400
Date: Thu, 6 May 2010 16:45:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: fix ti-st, depends on RFKILL
Message-Id: <20100506164510.06340a50.randy.dunlap@oracle.com>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BE354EB.0039:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors.  st_kim.c uses rfkill*() interfaces, so it
should depend on RFKILL.

st_kim.c:(.text+0x291b21): undefined reference to `rfkill_unregister'
st_kim.c:(.text+0x291b31): undefined reference to `rfkill_destroy'
st_kim.c:(.text+0x291d8a): undefined reference to `rfkill_alloc'
st_kim.c:(.text+0x291db9): undefined reference to `rfkill_init_sw_state'
st_kim.c:(.text+0x291dc9): undefined reference to `rfkill_register'
st_kim.c:(.text+0x291e07): undefined reference to `rfkill_unregister'
(.text+0x291e85): undefined reference to `rfkill_set_hw_state'
(.text+0x292072): undefined reference to `rfkill_set_hw_state'
(.text+0x2920e1): undefined reference to `rfkill_set_hw_state

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/ti-st/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100506.orig/drivers/staging/ti-st/Kconfig
+++ linux-next-20100506/drivers/staging/ti-st/Kconfig
@@ -5,6 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "shared transport core driver"
+	depends on RFKILL
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
