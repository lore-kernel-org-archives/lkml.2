Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1G1REw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:04:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44130 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab1G1REu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:04:50 -0400
Message-ID: <4E3196A1.3010505@gmail.com>
Date: Thu, 28 Jul 2011 10:04:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/lockdep.c:2532 trace_hardirqs_on_caller+0x6b/0x164()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the kernel barfed this up:

[   27.788905] ------------[ cut here ]------------
[   27.792811] WARNING: at kernel/lockdep.c:2532 
trace_hardirqs_on_caller+0x6b/0x164()
[   27.796539] Hardware name: MacBookPro2,2
[   27.800111] Modules linked in: bnep arc4 ecb ath9k mac80211 
ath9k_common ath9k_hw btusb bluetooth ath cfg80211 sky2 i2c_i801 joydev 
applesmc input_polldev appletouch uvcvideo videodev v4l2_compat_ioctl32 
radeon microcode ttm drm_kms_helper drm i2c_algo_bit rfkill iTCO_wdt 
iTCO_vendor_support i2c_core apple_bl video [last unloaded: scsi_wait_scan]
[   27.808066] Pid: 413, comm: bluetoothd Not tainted 
3.0.0-05684-ge371d46 #2
[   27.811979] Call Trace:
[   27.811990]  [<ffffffff8104f788>] warn_slowpath_common+0x83/0x9b
[   27.811997]  [<ffffffff814a03f3>] ? __bad_area_nosemaphore+0x3a/0x1bc
[   27.812000]  [<ffffffff8104f7ba>] warn_slowpath_null+0x1a/0x1c
[   27.812018]  [<ffffffff8107fa43>] trace_hardirqs_on_caller+0x6b/0x164
[   27.812022]  [<ffffffff8107fb49>] trace_hardirqs_on+0xd/0xf
[   27.812025]  [<ffffffff814a03f3>] __bad_area_nosemaphore+0x3a/0x1bc
[   27.812028]  [<ffffffff814a05d4>] bad_area+0x4a/0x51
[   27.812032]  [<ffffffff814ae2f1>] do_page_fault+0x230/0x38b
[   27.812036]  [<ffffffff8107c83b>] ? trace_hardirqs_off_caller+0x33/0x90
[   27.812041]  [<ffffffff8123400d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   27.812047]  [<ffffffff814ab575>] page_fault+0x25/0x30
[   27.812050] ---[ end trace 2ed648d504c98e26 ]---

full dmesg here:
http://fpaste.org/VFHu/

not harmful given its a warning, but might as well post so people can 
see. if there is a patch let me know and I will test.

Justin P. Mattock
