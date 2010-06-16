Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0FPIDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:03:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab0FPIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rCm3tIlnQKmFBhrSOpw1uiNRl+KpNRX89H/8iW345HVN5UrjXD3bM4eQ3i8Noo+GVn
         Div0IgoEbNNTV6jqkT2Jc9RYWPytpTqjhG0CXhDb5nnhMlvvRP27/c1o/lKb6b28LwG6
         /gW8Kv39/J8RfXiSv2eeNGO5xBScFw81EMqrc=
Message-ID: <4C18855E.5010508@gmail.com>
Date: Wed, 16 Jun 2010 11:03:42 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: INFO: task khubd:271 blocked for more than 120 seconds.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


We got this on our production system. Kernel: 2.6.26-2-amd64.
This seems to be related with http://bugzilla.kernel.org/show_bug.cgi?id=13316 and still is open. Sadly to have such long standing bugs in common used subsystems like USB.

Jun 15 06:25:01 accelerator57 kernel: imklog 3.18.6, log source = /proc/kmsg started.
Jun 16 00:36:55 accelerator57 kernel: [600606.885265] usb 6-1: USB disconnect, address 3
Jun 16 00:39:02 accelerator57 kernel: [600738.152638] INFO: task khubd:271 blocked for more than 120 seconds.
Jun 16 00:39:02 accelerator57 kernel: [600738.152682] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 16 00:39:02 accelerator57 kernel: [600738.155993] khubd         D ffff810916ca1400     0   271      2
Jun 16 00:39:02 accelerator57 kernel: [600738.156038]  ffff810919523d50 0000000000000046 363030365b3e363c 36323538382e3630
Jun 16 00:39:02 accelerator57 kernel: [600738.156118]  ffff810919521470 ffff810916dad220 ffff8109195216f8 00000000a00745a2
Jun 16 00:39:02 accelerator57 kernel: [600738.156197]  ffff810919523da4 ffff810916ca1600 0000000000000286 ffff8109148851c0
Jun 16 00:39:02 accelerator57 kernel: [600738.156245] Call Trace:
Jun 16 00:39:02 accelerator57 kernel: [600738.156308]  [<ffffffff8039035a>] usb_kill_urb+0xa8/0xdb
Jun 16 00:39:02 accelerator57 kernel: [600738.156612]  [<ffffffff80246111>] autoremove_wake_function+0x0/0x2e
Jun 16 00:39:02 accelerator57 kernel: [600738.156660]  [<ffffffff8038fa32>] usb_hcd_flush_endpoint+0xd4/0xeb
Jun 16 00:39:02 accelerator57 kernel: [600738.156707]  [<ffffffff80390a8e>] usb_disable_endpoint+0x5b/0x6d
Jun 16 00:39:02 accelerator57 kernel: [600738.156752]  [<ffffffff80390ac5>] usb_disable_device+0x25/0xe8
Jun 16 00:39:02 accelerator57 kernel: [600738.156792]  [<ffffffff8038c9cd>] usb_disconnect+0x92/0x142
Jun 16 00:39:02 accelerator57 kernel: [600738.156830]  [<ffffffff8038dc07>] hub_thread+0x3f9/0xcfd
Jun 16 00:39:02 accelerator57 kernel: [600738.156868]  [<ffffffff80246111>] autoremove_wake_function+0x0/0x2e
Jun 16 00:39:02 accelerator57 kernel: [600738.156910]  [<ffffffff8038d80e>] hub_thread+0x0/0xcfd
Jun 16 00:39:02 accelerator57 kernel: [600738.156952]  [<ffffffff80245feb>] kthread+0x47/0x74
Jun 16 00:39:02 accelerator57 kernel: [600738.156993]  [<ffffffff8023008d>] schedule_tail+0x27/0x5c
Jun 16 00:39:02 accelerator57 kernel: [600738.157036]  [<ffffffff8020cf38>] child_rip+0xa/0x12
Jun 16 00:39:02 accelerator57 kernel: [600738.157077]  [<ffffffff80245fa4>] kthread+0x0/0x74
Jun 16 00:39:02 accelerator57 kernel: [600738.157116]  [<ffffffff8020cf2e>] child_rip+0x0/0x12
Jun 16 00:39:02 accelerator57 kernel: [600738.157154]

