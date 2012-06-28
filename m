Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2F1Goe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:44:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28121 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2F1Goc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:44:32 -0400
Date: Thu, 28 Jun 2012 09:44:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/3] vfio: signedness bug in vfio_config_do_rw()
Message-ID: <20120628064425.GA11107@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340686552.1207.128.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "count" variable is unsigned here so the test for errors doesn't
work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a4f7321..10bc6a8 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1487,7 +1487,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 		if (perm->readfn) {
 			count = perm->readfn(vdev, *ppos, count,
 					     perm, offset, &val);
-			if (count < 0)
+			if ((ssize_t)count < 0)
 				return count;
 		}
 
