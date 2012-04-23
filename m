Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2DWUS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:18:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47648 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2DWUS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:18:56 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 16:18:56 -0400
Message-ID: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
Subject: what determines how firmware is loaded? (Q. on request_firmware details)
From: George Nychis <gnychis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I notice in an older version of Ubuntu that when I plugin a USB
wireless device its firmware is loaded via sysfs.  For example, this
would pop up in sysfs:
/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/compat_firmware/2-1/loading

In newer versions, I'm now seeing that the firmware seems to be loaded
directly via a Kernel thread that is spawned.  It checks for the
firmware in some firmware directory (e.g., /lib/firmware) and loads it
to the device.

I see in documentation that one method is referred to as asynchronous.
 Is this the  former or latter?

Has the former method of loading firmware been removed as the default?
 Is there any way to request that the firmware load be done manually
(the former method)?

It seems as though instead of calling request_firmware(), I could call
_request_firmware() with "uevent" set to 0?  This would force for
former behavior?

Does "nowait" also have to be 0?  I don't quite understand the
separation between uevent and nowait.

Thanks!
George
