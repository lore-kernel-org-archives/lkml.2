Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0FDKkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:40:06 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:56080 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0FDKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JUz7FUMwuAzsvbsyQj9yN4TQws0ZwmCNkaUKD0+GsigUBfiwqIVxhi71Ja2bBM+ca8
         QdLiqJKVMNls2Y//DBdfxU9DC/WYe0BQ4891sKnPeq+o6mS/t3kvX7rDRze84l6LZ/aE
         zYGpVtemjRdzEfpKG4YNkD/oOQ5GYvgOhKWzQ=
Date: Fri, 4 Jun 2010 12:39:51 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Staging: rc2860: return -EFAULT on copy_to_user errors
Message-ID: <20100604103951.GE5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining but we want to
return a negative error code.  This is in the ioctl handler and the
error code gets passed to userspace.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index 112da7a..6b8268d 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2522,6 +2522,8 @@ int rt28xx_sta_ioctl(IN struct net_device *net_dev,
 			Status =
 			    copy_to_user(erq->pointer, pAd->nickname,
 					 erq->length);
+			if (Status)
+				Status = -EFAULT;
 			break;
 		}
 	case SIOCGIWRATE:	/*get default bit rate (bps) */
