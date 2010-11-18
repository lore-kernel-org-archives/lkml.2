Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab0KRXyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:54:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab0KRXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=II/egTeLbYgkhkYypP4N1Qmoqjei8VR1BSAY85JXA2fsiULRSH7V9CTjOh6GUHiJsQ
         TY876zhIsZSVRlWvwUbGGJ5Fz3RR8ccuO0WxeDVG5Iz27Nm3n8L3zG1Xq3haWiykcIkZ
         ulUrH6sSBIZAvYlJuNAgYasugQA8t+/vt5ous=
Date: Fri, 19 Nov 2010 00:47:28 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: sleeping function called from invalid context
	at...mm/fault.c:1074
Message-ID: <20101118234728.GA1065@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

got this pretty confusing BUG, probably triggered by drivers/media/dvb/siano. I had 
femon & kaffeine running in parallel. In kaffeine output stopped so I did quit kaffeine, 
unplugged the DVB stick and reconnected:

Nov 18 15:00:05 localhost kernel: [116557.045363] usb 5-5: USB disconnect, address 17
Nov 18 15:00:05 localhost kernel: [116557.045475] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045479] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045483] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045486] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045489] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045492] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045495] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045498] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045501] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.045504] smsusb_onresponse: line: 71: error, urb status -108 (-ESHUTDOWN), 0 bytes
Nov 18 15:00:05 localhost kernel: [116557.060214] sms_ir_exit: 
Nov 18 15:00:24 localhost kernel: [116575.829453] BUG: sleeping function called from invalid context at /home/rz/rpmbuild/kernels/linux-2.6.36/arch/x8
6/mm/fault.c:1074
Nov 18 15:00:24 localhost kernel: [116575.829457] in_atomic(): 0, irqs_disabled(): 1, pid: 22905, name: femon
Nov 18 15:00:24 localhost kernel: [116575.829459] no locks held by femon/22905.
Nov 18 15:00:24 localhost kernel: [116575.829461] irq event stamp: 17262
Nov 18 15:00:24 localhost kernel: [116575.829463] hardirqs last  enabled at (17261): [<c135bd4b>] _raw_spin_unlock_irqrestore+0x3f/0x4c
Nov 18 15:00:24 localhost kernel: [116575.829472] hardirqs last disabled at (17262): [<c135b8dd>] _raw_spin_lock_irqsave+0x1a/0x3f
Nov 18 15:00:24 localhost kernel: [116575.829476] softirqs last  enabled at (17052): [<c103ad4a>] __do_softirq+0x168/0x170
Nov 18 15:00:24 localhost kernel: [116575.829481] softirqs last disabled at (17047): [<c103ad8b>] do_softirq+0x39/0x5e
Nov 18 15:00:24 localhost kernel: [116575.829486] Pid: 22905, comm: femon Not tainted 2.6.36v1 #2
Nov 18 15:00:24 localhost kernel: [116575.829488] Call Trace:
Nov 18 15:00:24 localhost kernel: [116575.829493]  [<c102d8d4>] __might_sleep+0xdb/0xe2
Nov 18 15:00:24 localhost kernel: [116575.829497]  [<c135ecc8>] do_page_fault+0x1c0/0x304
Nov 18 15:00:24 localhost kernel: [116575.829500]  [<c135eb08>] ? do_page_fault+0x0/0x304
Nov 18 15:00:24 localhost kernel: [116575.829504]  [<c135c85f>] error_code+0x5f/0x70
Nov 18 15:00:24 localhost kernel: [116575.829508]  [<c10500d8>] ? srcu_notifier_chain_register+0x14/0x72
Nov 18 15:00:24 localhost kernel: [116575.829511]  [<c135eb08>] ? do_page_fault+0x0/0x304
Nov 18 15:00:24 localhost kernel: [116575.829515]  [<c105bab5>] ? __lock_acquire+0x90/0xc26
Nov 18 15:00:24 localhost kernel: [116575.829518]  [<c105a125>] ? register_lock_class+0x17/0x295
Nov 18 15:00:24 localhost kernel: [116575.829521]  [<c105ace9>] ? mark_lock+0x1e/0x1e3
Nov 18 15:00:24 localhost kernel: [116575.829524]  [<c105bdac>] ? __lock_acquire+0x387/0xc26
Nov 18 15:00:24 localhost kernel: [116575.829527]  [<c105c6e5>] lock_acquire+0x9a/0xbd
Nov 18 15:00:24 localhost kernel: [116575.829537]  [<fa8e15a7>] ? smscore_find_client+0x1d/0x70 [smsmdtv]
Nov 18 15:00:24 localhost kernel: [116575.829540]  [<c135b8f2>] _raw_spin_lock_irqsave+0x2f/0x3f
Nov 18 15:00:24 localhost kernel: [116575.829544]  [<fa8e15a7>] ? smscore_find_client+0x1d/0x70 [smsmdtv]
Nov 18 15:00:24 localhost kernel: [116575.829549]  [<fa8e15a7>] smscore_find_client+0x1d/0x70 [smsmdtv]
Nov 18 15:00:24 localhost kernel: [116575.829552]  [<c105a125>] ? register_lock_class+0x17/0x295
Nov 18 15:00:24 localhost kernel: [116575.829557]  [<fa8e1711>] smscore_validate_client+0x35/0xab [smsmdtv]
Nov 18 15:00:24 localhost kernel: [116575.829562]  [<fa8e17e1>] smsclient_sendrequest+0x5a/0x75 [smsmdtv]
Nov 18 15:00:24 localhost kernel: [116575.829566]  [<fa9991f7>] smsdvb_sendrequest_and_wait+0x1f/0x44 [smsdvb]
Nov 18 15:00:24 localhost kernel: [116575.829570]  [<fa999250>] smsdvb_send_statistics_request+0x34/0x36 [smsdvb]
Nov 18 15:00:24 localhost kernel: [116575.829573]  [<fa999372>] smsdvb_read_status+0x17/0x2f [smsdvb]
Nov 18 15:00:24 localhost kernel: [116575.829582]  [<fa97c453>] dvb_frontend_ioctl_legacy+0x610/0xc0d [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829585]  [<c105ace9>] ? mark_lock+0x1e/0x1e3
Nov 18 15:00:24 localhost kernel: [116575.829588]  [<c105a125>] ? register_lock_class+0x17/0x295
Nov 18 15:00:24 localhost kernel: [116575.829593]  [<c11c3f6b>] ? do_raw_spin_lock+0x53/0x104
Nov 18 15:00:24 localhost kernel: [116575.829596]  [<c135bd4b>] ? _raw_spin_unlock_irqrestore+0x3f/0x4c
Nov 18 15:00:24 localhost kernel: [116575.829599]  [<c105b165>] ? trace_hardirqs_on_caller+0x10d/0x12e
Nov 18 15:00:24 localhost kernel: [116575.829602]  [<c105b191>] ? trace_hardirqs_on+0xb/0xd
Nov 18 15:00:24 localhost kernel: [116575.829606]  [<c104ff37>] ? down_interruptible+0xd/0x37
Nov 18 15:00:24 localhost kernel: [116575.829609]  [<c104ff5a>] ? down_interruptible+0x30/0x37
Nov 18 15:00:24 localhost kernel: [116575.829616]  [<fa97d5a6>] dvb_frontend_ioctl+0xb56/0xb88 [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829620]  [<c10b6e52>] ? might_fault+0x7c/0x81
Nov 18 15:00:24 localhost kernel: [116575.829624]  [<c11c0bf9>] ? _copy_from_user+0x2d/0x106
Nov 18 15:00:24 localhost kernel: [116575.829627]  [<c135bd03>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 18 15:00:24 localhost kernel: [116575.829633]  [<fa9752ee>] dvb_usercopy+0xb5/0x113 [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829636]  [<c11c3f6b>] ? do_raw_spin_lock+0x53/0x104
Nov 18 15:00:24 localhost kernel: [116575.829640]  [<c135bd4b>] ? _raw_spin_unlock_irqrestore+0x3f/0x4c
Nov 18 15:00:24 localhost kernel: [116575.829643]  [<c105b165>] ? trace_hardirqs_on_caller+0x10d/0x12e
Nov 18 15:00:24 localhost kernel: [116575.829646]  [<c11c3f6b>] ? do_raw_spin_lock+0x53/0x104
Nov 18 15:00:24 localhost kernel: [116575.829649]  [<c105b191>] ? trace_hardirqs_on+0xb/0xd
Nov 18 15:00:24 localhost kernel: [116575.829652]  [<c135bed4>] ? _lock_kernel+0x69/0x7a
Nov 18 15:00:24 localhost kernel: [116575.829658]  [<fa97539b>] dvb_generic_ioctl+0x4f/0x70 [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829664]  [<fa97ca50>] ? dvb_frontend_ioctl+0x0/0xb88 [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829670]  [<fa97534c>] ? dvb_generic_ioctl+0x0/0x70 [dvb_core]
Nov 18 15:00:24 localhost kernel: [116575.829674]  [<c10e44ae>] do_vfs_ioctl+0x4c7/0x508
Nov 18 15:00:24 localhost kernel: [116575.829677]  [<c104eb42>] ? hrtimer_wakeup+0x0/0x1c
Nov 18 15:00:24 localhost kernel: [116575.829681]  [<c104f629>] ? hrtimer_start_range_ns+0x10/0x12
Nov 18 15:00:24 localhost kernel: [116575.829684]  [<c10e452f>] sys_ioctl+0x40/0x5a
Nov 18 15:00:24 localhost kernel: [116575.829687]  [<c135c015>] syscall_call+0x7/0xb

Can not make much sense out of the backtrace, any ideas?

Richard
