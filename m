Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1AURTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:19:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43576 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1AURTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:19:48 -0500
Date: Fri, 21 Jan 2011 09:18:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@suse.de>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH -next] staging/hv: hv_utils depends on CONNECTOR
Message-Id: <20110121091856.bd5b10af.randy.dunlap@oracle.com>
In-Reply-To: <20110121132707.27768675.sfr@canb.auug.org.au>
References: <20110121132707.27768675.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Don't build hv_utils when CONFIG_CONNECTOR is not enabled.
Fixes these build errors:

ERROR: "cn_add_callback" [drivers/staging/hv/hv_utils.ko] undefined!
ERROR: "cn_del_callback" [drivers/staging/hv/hv_utils.ko] undefined!
ERROR: "cn_netlink_send" [drivers/staging/hv/hv_utils.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110121.orig/drivers/staging/hv/Kconfig
+++ linux-next-20110121/drivers/staging/hv/Kconfig
@@ -31,6 +31,7 @@ config HYPERV_NET
 
 config HYPERV_UTILS
 	tristate "Microsoft Hyper-V Utilities driver"
+	depends on CONNECTOR
 	default HYPERV
 	help
 	  Select this option to enable the Hyper-V Utilities.
