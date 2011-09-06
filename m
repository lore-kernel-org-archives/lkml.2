Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1IFMJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:09:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33411 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1IFMJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:09:05 -0400
Date: Tue, 6 Sep 2011 20:08:08 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l2: uvcvideo use after free bug fix
Message-ID: <20110906120808.GC2321@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Unplugging uvc video camera trigger following oops:

eeepc kernel: [ 1393.500719] usb 3-2: USB disconnect, device number 4
eeepc kernel: [ 1393.504351] uvcvideo: Failed to resubmit video URB (-19).
eeepc kernel: [ 1495.428853] BUG: unable to handle kernel paging request at 6b6b6bcb
eeepc kernel: [ 1495.429017] IP: [<b0358d37>] dev_get_drvdata+0x17/0x20
eeepc kernel: [ 1495.429017] *pde = 00000000 
eeepc kernel: [ 1495.429017] Oops: 0000 [#1] DEBUG_PAGEALLOC
eeepc kernel: [ 1495.429017] 
eeepc kernel: [ 1495.429017] Pid: 3476, comm: cheese Not tainted 3.1.0-rc3-00270-g7a54f5e-dirty #485 ASUSTeK Computer INC. 900/900
eeepc kernel: [ 1495.429017] EIP: 0060:[<b0358d37>] EFLAGS: 00010202 CPU: 0
eeepc kernel: [ 1495.429017] EIP is at dev_get_drvdata+0x17/0x20
eeepc kernel: [ 1495.429017] EAX: 6b6b6b6b EBX: eb08d870 ECX: 00000000 EDX: eb08d930
eeepc kernel: [ 1495.429017] ESI: eb08d870 EDI: eb08d870 EBP: d3249cac ESP: d3249cac
eeepc kernel: [ 1495.429017]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
eeepc kernel: [ 1495.429017] Process cheese (pid: 3476, ti=d3248000 task=df46d870 task.ti=d3248000)
eeepc kernel: [ 1495.429017] Stack:
eeepc kernel: [ 1495.429017]  d3249cb8 b03e77a1 d307b840 d3249ccc b03e77d1 d307b840 eb08d870 eb08d830
eeepc kernel: [ 1495.429017]  d3249ce4 b03ed3b7 00000246 d307b840 eb08d870 d3021b80 d3249cec b03ed565
eeepc kernel: [ 1495.429017]  d3249cfc b03e044d e8323d10 b06e013c d3249d18 b0355fb9 fffffffe d3249d1c
eeepc kernel: [ 1495.429017] Call Trace:
eeepc kernel: [ 1495.429017]  [<b03e77a1>] v4l2_device_disconnect+0x11/0x30
eeepc kernel: [ 1495.429017]  [<b03e77d1>] v4l2_device_unregister+0x11/0x50
eeepc kernel: [ 1495.429017]  [<b03ed3b7>] uvc_delete+0x37/0x110
eeepc kernel: [ 1495.429017]  [<b03ed565>] uvc_release+0x25/0x30
eeepc kernel: [ 1495.429017]  [<b03e044d>] v4l2_device_release+0x9d/0xc0
eeepc kernel: [ 1495.429017]  [<b0355fb9>] device_release+0x19/0x90
eeepc kernel: [ 1495.429017]  [<b03adfdc>] ? usb_hcd_unlink_urb+0x7c/0x90
eeepc kernel: [ 1495.429017]  [<b026b99c>] kobject_release+0x3c/0x90
eeepc kernel: [ 1495.429017]  [<b026b960>] ? kobject_del+0x30/0x30
eeepc kernel: [ 1495.429017]  [<b026ca4c>] kref_put+0x2c/0x60
eeepc kernel: [ 1495.429017]  [<b026b88d>] kobject_put+0x1d/0x50
eeepc kernel: [ 1495.429017]  [<b03b2385>] ? usb_autopm_put_interface+0x25/0x30
eeepc kernel: [ 1495.429017]  [<b03f0e5d>] ? uvc_v4l2_release+0x5d/0xd0
eeepc kernel: [ 1495.429017]  [<b0355d2f>] put_device+0xf/0x20
eeepc kernel: [ 1495.429017]  [<b03dfa96>] v4l2_release+0x56/0x60
eeepc kernel: [ 1495.429017]  [<b019c8dc>] fput+0xcc/0x220
eeepc kernel: [ 1495.429017]  [<b01990f4>] filp_close+0x44/0x70
eeepc kernel: [ 1495.429017]  [<b012b238>] put_files_struct+0x158/0x180
eeepc kernel: [ 1495.429017]  [<b012b100>] ? put_files_struct+0x20/0x180
eeepc kernel: [ 1495.429017]  [<b012b2a0>] exit_files+0x40/0x50
eeepc kernel: [ 1495.429017]  [<b012b9e7>] do_exit+0x5a7/0x660
eeepc kernel: [ 1495.429017]  [<b0135f72>] ? __dequeue_signal+0x12/0x120
eeepc kernel: [ 1495.429017]  [<b055edf2>] ? _raw_spin_unlock_irq+0x22/0x30
eeepc kernel: [ 1495.429017]  [<b012badc>] do_group_exit+0x3c/0xb0
eeepc kernel: [ 1495.429017]  [<b015792b>] ? trace_hardirqs_on+0xb/0x10
eeepc kernel: [ 1495.429017]  [<b013755f>] get_signal_to_deliver+0x18f/0x570
eeepc kernel: [ 1495.429017]  [<b01020f7>] do_signal+0x47/0x9e0
eeepc kernel: [ 1495.429017]  [<b055edf2>] ? _raw_spin_unlock_irq+0x22/0x30
eeepc kernel: [ 1495.429017]  [<b015792b>] ? trace_hardirqs_on+0xb/0x10
eeepc kernel: [ 1495.429017]  [<b0123300>] ? T.1034+0x30/0xc0
eeepc kernel: [ 1495.429017]  [<b055c45f>] ? schedule+0x29f/0x640
eeepc kernel: [ 1495.429017]  [<b0102ac8>] do_notify_resume+0x38/0x40
eeepc kernel: [ 1495.429017]  [<b055f154>] work_notifysig+0x9/0x11
eeepc kernel: [ 1495.429017] Code: e5 5d 83 f8 01 19 c0 f7 d0 83 e0 f0 c3 8d b4 26 00 00 00 00 55 85 c0 89 e5 75 09 31 c0 5d c3 90 8d 74 26 00 8b 40 04 85 c0 74 f0 <8b> 40 60 5d c3 8d 74 26 00 55 89 e5 53 89 c3 83 ec 04 8b 40 04 
eeepc kernel: [ 1495.429017] EIP: [<b0358d37>] dev_get_drvdata+0x17/0x20 SS:ESP 0068:d3249cac
eeepc kernel: [ 1495.429017] CR2: 000000006b6b6bcb
eeepc kernel: [ 1495.466975] uvcvideo: Failed to resubmit video URB (-27).
eeepc kernel: [ 1495.467860] uvcvideo: Failed to resubmit video URB (-27).
eeepc kernel: last message repeated 3 times
eeepc kernel: [ 1495.512610] ---[ end trace 73ec16848794e5a5 ]---

For uvc device, dev->vdev.dev is the &intf->dev,
uvc_delete code is as below:
	usb_put_intf(dev->intf);
	usb_put_dev(dev->udev);

	uvc_status_cleanup(dev);
	uvc_ctrl_cleanup_device(dev);

## the intf dev is released above, so below code will oops.

	if (dev->vdev.dev)
		v4l2_device_unregister(&dev->vdev);

Fix it by get_device in v4l2_device_register and put_device in v4l2_device_disconnect
---
 drivers/media/video/v4l2-device.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index c72856c..e6a2c3b 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -38,6 +38,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 	mutex_init(&v4l2_dev->ioctl_lock);
 	v4l2_prio_init(&v4l2_dev->prio);
 	kref_init(&v4l2_dev->ref);
+	get_device(dev);
 	v4l2_dev->dev = dev;
 	if (dev == NULL) {
 		/* If dev == NULL, then name must be filled in by the caller */
@@ -93,6 +94,7 @@ void v4l2_device_disconnect(struct v4l2_device *v4l2_dev)
 
 	if (dev_get_drvdata(v4l2_dev->dev) == v4l2_dev)
 		dev_set_drvdata(v4l2_dev->dev, NULL);
+	put_device(v4l2_dev->dev);
 	v4l2_dev->dev = NULL;
 }
 EXPORT_SYMBOL_GPL(v4l2_device_disconnect);
