Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0L1JYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 04:24:14 -0500
Received: from mxs.selfip.ru ([77.221.143.26]:32804 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632Ab0L1JYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 04:24:11 -0500
X-ACL-SPF: 
Subject: change partition table on live disk (resize root partition)
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Tue, 28 Dec 2010 12:24:09 +0300
Message-ID: <1293528249.8310.8.camel@vase>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

If i need to resize root partition on live file system i do
fdisk /dev/sda delete old partition table and write new. After that
fdisk say's that system use old partition table before reread it via
partprobe or something else.

But if i modify root partition partprobe say's that it is already in use
and i need to reboot system to see changes and do resize fs.

Is that possible to reread partition table for root fs without
rebooting? I ca'n use lvm on something else, i'm use plain ext3 fs.


P.S. This is need for xen domU, i see that in blkfront_connect function
this code:

                /*
                 * Potentially, the back-end may be signalling
                 * a capacity change; update the capacity.
                 */
                err = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
                                   "sectors", "%Lu", &sectors);
                if (XENBUS_EXIST_ERR(err))
                        return;
                printk(KERN_INFO "Setting capacity to %Lu\n",
                       sectors);
                set_capacity(info->gd, sectors);
                revalidate_disk(info->gd);

If i'm add after revalidate disk some function to reread partiotion
table does it can work?

Sorry for may be stupid question...


-- 
Vasiliy G Tolstov <v.tolstov@selfip.ru>
Selfip.Ru

