Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2BTCnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:43:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2BTCnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:43:13 -0500
MIME-Version: 1.0
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 20 Feb 2012 10:42:53 +0800
Message-ID: <CAO_0yfPDFUw-xWA9Ce0HiOMv_3PAP_2+1QzP1SqVQ9UhThX9pQ@mail.gmail.com>
Subject: [BUG] SCSI device hot plug out with /dev node left
To: JBottomley@parallels.com, julia@diku.dk, nagalakshmi.nandigama@lsi.com,
        kashyap.desai@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During our test on kernel 2.6.32, we found a problem about SCSI device
hot-plug and this may be a bug. Our SCSI host is MPT2SAS.
assume the SCSI disk is /dev/sdb and it's SCSI ID is 0:0:1:0.

First,  Let's mount it at /mnt/test with following command:

mount /dev/sdb /mnt/test

now we can access this disk through /mnt/test

Then we hot plug out this device as following:

echo 1 > /sys/block/sdb/device/delete

At here, /mnt/test is not accessible but /dev/sdb is still there.

Then we re-scan the host:
echo "0 1 0" > /sys/class/scsi_host/host0/scan

We found that a new dev node such as sdf is allocated to this disk but
sdb is not freed and is not reusable.
We want that sdb can be freed when we hot plug-out the disk and can be
reused when we plug-in a new disk.

Is this some kind of bug?  Has it been fixed in the newer version?
Any suggestion or any workaround?

Thanks,
Yang
