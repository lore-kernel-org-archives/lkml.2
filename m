Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1FTMIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:08:30 -0400
Received: from fallback8.mail.ru ([94.100.176.136]:33426 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1FTMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:08:29 -0400
X-Greylist: delayed 736 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jun 2011 08:08:28 EDT
Message-ID: <4DFF35CC.7070606@mail.ru>
Date: Mon, 20 Jun 2011 15:58:04 +0400
From: Nikolai Zhubr <zhubr@mail.ru>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: jffs2 oops
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello people,

I'm getting an oops in (or closely related to) JFFS2 filesystem in 
stable kernel 2.6.36.4 on ARM with real MTD memory and also in some 
2.6.34-12-desktop (opensuse 11.3) kernel on x86_64 with mtdram emulator.

The oops is fully reproducible and happens immediately on mount attempt. 
I think, the data was not even subject to sudden power failure or any 
such event. Just upon normal reboot it failed to mount.

The image (300Kb) can be found here:
http://n-a-zhubr.narod.ru/openwrt/jffs2oops.img.gz
(hopefully the link works for all, otherwise I can email it personally)
Note: the size of erase block is (intensionally) 256K, not 64.

Please CC me, I'm not subscribed.
Thank you.
Nikolai ZHUBR
===================================================================
JFFS2 error: (233) jffs2_link_node_ref: Adding new ref c59eaeec at 
(0x00000000-0x00000034) not immediately after previous 
(0x00000000-0x00000000)
kernel BUG at fs/jffs2/nodelist.c:644!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c59ec000
[00000000] *pgd=059e8031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:
CPU: 0    Not tainted  (2.6.36.4 #50)

2.6.34-12-desktop:
kernel:[ 1192.811506] ------------[ cut here ]------------
kernel:[ 1192.811512] invalid opcode: 0000 [#1] PREEMPT SMP
kernel:[ 1192.811515] last sysfs file: /sys/devices/virtual/bdi/31:0/uevent
kernel:[ 1192.811628] Stack:
kernel:[ 1192.811640] Call Trace:
kernel:[ 1192.811805] Code: 8b b6 b0 02 00 00 41 83 e0 fc 46 8d 0c 01 48 
89 d9 83 e2 fc 01 d0 89 14 24 48 c7 c2 50 4f aa a0 89 44 24 08 31 c0 e8 
9e d7 a0 e0 <0f> 0b 0f 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08
