Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2F1Gpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:45:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28596 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2F1Gpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:45:33 -0400
Date: Thu, 28 Jun 2012 09:45:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 3/3] vfio: return -EFAULT on failure
Message-ID: <20120628064524.GC11107@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340686552.1207.128.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ioctl function is supposed to return a negative error code or zero
on success.  copy_to_user() returns zero or the number of bytes
remaining to be copied.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 457acf3..1aa373f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1159,6 +1159,8 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET;
 
 		ret = copy_to_user((void __user *)arg, &status, minsz);
+		if (ret)
+			ret = -EFAULT;
 
 		break;
 	}
