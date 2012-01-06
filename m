Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab2AFOdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:33:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40803 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2AFOdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:33:23 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Burgess'" <aab@cichlid.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-uvc-devel@lists.berlios.de>
References: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com> (from jpiszcz@lucidpixels.com on Tue Jan  3 06:21:02 2012) <1325694071.16950.49@hogo> <003301cccb03$4a8cbea0$dfa63be0$@lucidpixels.com> <017d01cccbfe$e3a82100$aaf86300$@lucidpixels.com>
In-Reply-To: <017d01cccbfe$e3a82100$aaf86300$@lucidpixels.com>
Subject: RE: 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
Date: Fri, 6 Jan 2012 09:33:20 -0500
Message-ID: <007501cccc80$2370b190$6a5214b0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEP3FQPGNkjbsETjYM87qM0UoHbNAGqYLYAAwAb7q8BXgy8XpdJAwEQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Andrew Burgess [mailto:aab@cichlid.com] 

it sounds like a bug recently tracked down on the usb devel list
(search for 'Failed to resubmit video URB')

it turned out to be a bug in the usb host controller; if you
do an lspci do you see anything made by NetMos or MosChip?

--

Hi,

Running kernel 3.2 for 12+ hours, no issues yet, will update thread if any further issues occur.

Justin.

--

With 3.2+ it locked up again:

motion    3298  0.2  0.2 178756 16584 ?        Dl   Jan05   4:46 /usr/bin/motio

[70440.477114] INFO: task motion:3298 blocked for more than 120 seconds.
[70440.477122] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[70440.477129] motion          D 0000000000000000     0  3298      1 0x00000000
[70440.477140]  ffff8802327edb98 0000000000000082 0000000000000000 ffff8802327edfd8
[70440.477152]  0000000000004000 ffff8802327edfd8 ffffffff8180d020 ffff88022fe3f990
[70440.477161]  ffffffff81831d80 ffff880236bd7800 ffff8802327edaf8 0000000000000286
[70440.477171] Call Trace:
[70440.477185]  [<ffffffff8110d15e>] ? sysfs_addrm_finish+0x2e/0xb0
[70440.477196]  [<ffffffff812c5c49>] ? kobject_release+0x59/0xa0
[70440.477204]  [<ffffffff812c5bf0>] ? kobject_del+0x40/0x40
[70440.477214]  [<ffffffff813b7df2>] ? ehci_endpoint_disable+0xc2/0x160
[70440.477223]  [<ffffffff8159edea>] schedule+0x3a/0x50
[70440.477231]  [<ffffffff8159fa21>] __mutex_lock_slowpath+0xc1/0x130
[70440.477238]  [<ffffffff8159f85d>] mutex_lock+0x1d/0x40
[70440.477245]  [<ffffffff81422d52>] uvc_queue_enable+0x22/0xd0
[70440.477252]  [<ffffffff81426b1a>] uvc_video_enable+0x9a/0xb0
[70440.477259]  [<ffffffff814240df>] uvc_v4l2_do_ioctl+0x4cf/0x1310
[70440.477268]  [<ffffffff814172cf>] video_usercopy+0x1bf/0x4e0
[70440.477275]  [<ffffffff81423c10>] ? uvc_v4l2_set_streamparm.isra.11+0x190/0x190
[70440.477282]  [<ffffffff81423494>] uvc_v4l2_ioctl+0x24/0x70
[70440.477289]  [<ffffffff81410a47>] v4l2_ioctl+0xb7/0x150
[70440.477298]  [<ffffffff810c0b8e>] do_vfs_ioctl+0x8e/0x4e0
[70440.477306]  [<ffffffff810c102a>] sys_ioctl+0x4a/0x80
[70440.477316]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b

Justin.

