Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0JNEE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:04:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48678 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0JNEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:04:23 -0400
Date: Wed, 13 Oct 2010 18:12:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH -next] infiniband: fix mlx4 kconfig dependency warning
Message-Id: <20101013181253.f3f5cd6f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (MLX4_EN && NETDEVICES && NETDEV_10000 && PCI && INET || MLX4_INFINIBAND && INFINIBAND) selects MLX4_CORE which has unmet direct dependencies (NETDEVICES && NETDEV_10000 && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/infiniband/hw/mlx4/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101013.orig/drivers/infiniband/hw/mlx4/Kconfig
+++ linux-next-20101013/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,5 +1,6 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
+	depends on NETDEVICES && NETDEV_10000 && PCI
 	select MLX4_CORE
 	---help---
 	  This driver provides low-level InfiniBand support for
