Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2FJLE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:04:29 -0400
Received: from ferdi.naasa.net ([87.106.227.76]:46111 "EHLO ferdi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2FJLE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:04:28 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2012 07:04:28 EDT
Message-ID: <4FD47D4E.9070307@naasa.net>
Date: Sun, 10 Jun 2012 12:56:14 +0200
From: Joerg Platte <jplatte@naasa.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120418 Icedove/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.4.X NFS regression
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All 3.4 kernels I tried so far (3.4, 3.4.1 and 3.4.2) suffer from the 
same NFS related problem:

Jun 10 09:23:36 coco kernel: INFO: task kworker/u:1:8 blocked for more 
than 120 seconds.
Jun 10 09:23:36 coco kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 09:23:36 coco kernel: kworker/u:1     D 002ba28c     0     8 
  2 0x00000000
Jun 10 09:23:36 coco kernel:  df465ec0 00000046 00000005 002ba28c 
00000000 0000000a 00000282 df465e70
Jun 10 09:23:36 coco kernel:  df465ec0 df44d2b0 ffff6b60 df465e84 
df44d2b0 e33fa6b3 00000282 de764ae0
Jun 10 09:23:36 coco kernel:  ffffffff d78bcfb8 df465e8c c012e0f6 
df465ea4 c013610c 00000000 d78bcf80
Jun 10 09:23:36 coco kernel: Call Trace:
Jun 10 09:23:36 coco kernel:  [<c012e0f6>] ? add_timer+0x11/0x17
Jun 10 09:23:36 coco kernel:  [<c013610c>] ? queue_delayed_work_on+0x74/0xf0
Jun 10 09:23:36 coco kernel:  [<c0136ba4>] ? queue_delayed_work+0x1b/0x28
Jun 10 09:23:36 coco kernel:  [<c0350f5b>] schedule+0x1d/0x4c
Jun 10 09:23:36 coco kernel:  [<e0cda5f1>] cld_pipe_upcall+0x4e/0x75 [nfsd]
Jun 10 09:23:36 coco kernel:  [<e0cda678>] 
nfsd4_cld_grace_done+0x60/0x99 [nfsd]
Jun 10 09:23:36 coco kernel:  [<e0cd9cb5>] 
nfsd4_record_grace_done+0x10/0x12 [nfsd]
Jun 10 09:23:36 coco kernel:  [<e0cd6696>] laundromat_main+0x291/0x2d8 
[nfsd]
Jun 10 09:23:36 coco kernel:  [<c0136d2f>] process_one_work+0xff/0x325
Jun 10 09:23:36 coco kernel:  [<c0134bec>] ? start_worker+0x20/0x23
Jun 10 09:23:36 coco kernel:  [<e0cd6405>] ? 
nfsd4_process_open1+0x32b/0x32b [nfsd]
Jun 10 09:23:36 coco kernel:  [<c013727a>] worker_thread+0xf4/0x39a
Jun 10 09:23:36 coco kernel:  [<c0137186>] ? rescuer_thread+0x231/0x231
Jun 10 09:23:36 coco kernel:  [<c013a556>] kthread+0x6c/0x6e
Jun 10 09:23:36 coco kernel:  [<c013a4ea>] ? kthreadd+0xe8/0xe8
Jun 10 09:23:36 coco kernel:  [<c035263e>] kernel_thread_helper+0x6/0xd

A kworker task is stuck in D state and nfs mounts from other clients do 
not work at all. This happens only on one machine, another one with the 
same kernel (same self compiled Debian package) works. All previous 3.3 
kernels work as well.

Since this machine is remote it is not that easy to bisect to find the 
bad commit. Are there any other things I can try?

regards,
Joerg
