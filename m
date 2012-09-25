Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2IYPNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:13:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49643 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2IYPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:13:49 -0400
Message-ID: <5061CA27.7060006@gmail.com>
Date: Tue, 25 Sep 2012 23:13:43 +0800
From: Lan Tianyu <lantianyu1986@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Firefox/15.0.1 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Question about dev_uevent_filter
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Greg:
	I find only devices which has bus_type or class can add uevent callback
and output the uevent information. This is because the dev_uevent_filter just return
true for these devices. But some device may not have class and bus_type.
e.g usb endpoint, if we assigned them to usb_bus_type, device core will
try to create sysfs directory link under /sys/bus/usb. But endpoint sysfs
directory's name are same for each usb devices.e.g ep_00, every usb device will
create the endpoint. So in this situation, we can't assign usb endpoint to
usb_bus_type. So even if uevent callback was added and with some information,
it still couldn't output anything. Can we add dev->type check in the
dev_uevent_filter() and return 1 if type exits?

/drivers/base/core.c
static int dev_uevent_filter(struct kset *kset, struct kobject *kobj)
{
	struct kobj_type *ktype = get_ktype(kobj);

	if (ktype == &device_ktype) {
		struct device *dev = kobj_to_dev(kobj);
		if (dev->bus)
			return 1;
		if (dev->class)
			return 1;
	}
	return 0;
}

Thanks
-- 
Best regards
Tianyu Lan
