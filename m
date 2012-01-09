Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2AIKzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:55:18 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16547 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2AIKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:55:16 -0500
Date: Mon, 9 Jan 2012 13:54:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Len Brown <len.brown@intel.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Kevin Hilman <khilman@ti.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cpuidle: checking the wrong variable in
 __cpuidle_register_device()
Message-ID: <20120109105454.GA6940@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F0AC78E.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We updated this in 8a25a2fd12 "cpu: convert 'cpu' and 'machinecheck'
sysdev_class to a regular subsystem" but it should be checking "cpu_dev"
here not "dev".  The "dev" variable was dereferenced already.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..7771810 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -294,7 +294,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!dev)
+	if (!cpu_dev)
 		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
