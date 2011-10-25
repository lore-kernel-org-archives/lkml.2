Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1JYLI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:08:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63274 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab1JYLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:08:57 -0400
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 20:08:55 +0900
Message-ID: <CAME+iufebpYZ-0-H6KbORzxz30dPTQYfPLmvdLnDGFGT+FPKQg@mail.gmail.com>
Subject: problem with UBIFS - Nand - Android
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have a custom board of OMAP 3530 and I had been successful at
bringing up Android.
Recently I changed my NAND to UBIFS and after a few reboots, I have
this workqueue-error and android stops booting.

I googled around and found some hints with respect to Frame Buffer
settings, and none of them worked for me.
Also, I did "nand scrub" from u-boot, and re-wrote the kernel to the
NAND, system boots comfortably.

Any idea how I can fix this?

Thanks in advance
Murali

Kernel log:
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:485 flush_cpu_workqueue+0x34/0x8c()
Modules linked in:  omaplfb pvrsrvk  sdmak lpm_omap3530 dsplinkk  cmemk
[<c003f9a4>] (unwind_backtrace+0x0/0xe0) from [<c0064940>]
(warn_slowpath_common+0x48/0x60)
[<c0064940>] (warn_slowpath_common+0x48/0x60) from [<c0073538>]
(flush_cpu_workqueue+0x34/0x8c)
[<c0073538>] (flush_cpu_workqueue+0x34/0x8c) from [<c02119a8>]
(tty_ldisc_release+0x20/0x68)
[<c02119a8>] (tty_ldisc_release+0x20/0x68) from [<c020cba4>]
(tty_release+0x39c/0x3fc)
[<c00b7bd0>] (__fput+0x104/0x1c4) from [<c00b4ef4>] (filp_close+0x70/0x7c)
[<c020cba4>] (tty_release+0x39c/0x3fc) from [<c00b7bd0>] (__fput+0x104/0x1c4)
[<c00b4ef4>] (filp_close+0x70/0x7c) from [<c006640c>]
(put_files_struct+0x7c/0xd0)
[<c006640c>] (put_files_struct+0x7c/0xd0) from [<c0368a0c>]
(binder_deferred_func+0x4f0/0x530)
[<c0368a0c>] (binder_deferred_func+0x4f0/0x530) from [<c0073d30>]
(worker_thread+0x138/0x1b0)
[<c0073d30>] (worker_thread+0x138/0x1b0) from [<c0076834>] (kthread+0x7c/0x84)
[<c0076834>] (kthread+0x7c/0x84) from [<c003ae44>] (kernel_thread_exit+0x0/0x8)
---[ end trace  1b75b31a2719ed1e]---

Android Logcat (last few messages):

D/PackageManager( 1292): Scanning app dir /data/app-private
I/PackageManager( 1292): Time to scan packages: 4.829 seconds
W/PackageManager( 1292): Unknown permission
com.google.android.gm.permission.WRITE_GMAIL in package
com.android.settings
W/PackageManager( 1292): Unknown permission
com.google.android.gm.permission.READ_GMAIL in package
com.android.settings
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH in package
com.android.settings
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH in package
com.android.providers.contacts
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH.cp in package
com.android.providers.contacts
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH.mail in package
com.android.contacts
W/PackageManager( 1292): Not granting permission
android.permission.CALL_PRIVILEGED to package com.SBN
(protectionLevel=3 flags=0xbe46)
W/PackageManager( 1292): Not granting permission
android.permission.STATUS_BAR to package com.SBN (protectionLevel=3
flags=0xbe46)
W/PackageManager( 1292): Not granting permission
android.permission.DEVICE_POWER to package com.SBN (protectionLevel=2
flags=0xbe46)
W/PackageManager( 1292): Unknown permission
android.webkit.permission.PLUGIN in package com.adobe.flashplayer
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH in package
com.android.providers.calendar
W/PackageManager( 1292): Unknown permission
com.google.android.googleapps.permission.GOOGLE_AUTH.cl in package
com.android.providers.calendar
W/PackageManager( 1292): Not granting permission
android.permission.SEND_DOWNLOA D_COMPLETED_INTENTS to package
com.android.browser (protectionLevel=2 flags=0x1be45)
W/PackageManager( 1292): Not granting permmission
android.permission.DEVICE_POWER to package com.android.de skclock
(protectionLevel=2 flags=0xbe45)
E/System  ( 1292): Failure starting core service
E/System  ( 1292): java.lang.NullPointerException
E/System  ( 1292): at
com.android.server.PackageManagerService$PackageSignatures.writeXml(PackageManagerService.java:7309)
E/System  ( 1292): at
com.android.server.PackageManagerService$Settings.writePackage(PackageManagerService.java:8638)
E/System  ( 1292):      at
com.android.server.PackageManagerService$Settings.writeLP(PackageManagerService.java:8427)
E/System  ( 1292):      at com.android.serverbinder: 1292:
binder_alloc_buf, no vma.PackageManagerService.<init>(Pabinder:
1305:1311 transaction failed 29201, size 60-0
ckageManagerService.java:994)
E/System  ( 1292):      at
com.android.server.PackageManagerService.mrequest_suspend_state:
wakeup (3->0) at 21906677250 (1970-01-01 00:00:21.906677250 UTC)
ain(PackageManagerService.java:681)
E/System  ( 1292):      at
com.android.server.ServerThread.run(SystemServer.java:122)
I/SystemServer( 1292): Device Policy
E/SystemServer( 1292): Failure starting DevicePolicyService
                       init: untracked pid 1157 exited

E/SystemServer( 1292): java.lang.NullPointerException
