Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0EaTBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:01:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34039 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0EaTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:01:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: fix error at the default input_get_keycode call
In-Reply-To: Your message of "Thu, 20 May 2010 13:51:46 EDT."
             <9427.1274377906@localhost>
From: Valdis.Kletnieks@vt.edu
References: <4BF4C0D6.9030808@redhat.com>
            <9427.1274377906@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275332484_6730P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 31 May 2010 15:01:24 -0400
Message-ID: <48947.1275332484@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C040784.00FC,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275332484_6730P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 May 2010 13:51:46 EDT, Valdis.Kletnieks@vt.edu said:

*ping*?  Still broken in a linux-next pull I did about an hour ago.  The
patch fixed one oops, but it just died a little further down - I'm guessing
it missed a case?

> > input_default_getkeycode_from_index() returns the scancode at kt_entry.scancode
> > pointer. Fill it with the scancode address at the function call.
> > 
> > Thanks-to: Vladis Kletnieks <Valdis.Kletnieks@vt.edu> for pointing the issue
> > 
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > diff --git a/drivers/input/input.c b/drivers/input/input.c
> > index 3b63fad..7851d8e 100644
> 
> Still dies, but in input_set_keycode() instead...
> 
> [   35.294528] BUG: unable to handle kernel NULL pointer dereference at (null
)
> [   35.295005] IP: [<(null)>] (null)
> [   35.296935] PGD 11da3c067 PUD 11d4ad067 PMD 0 
> [   35.296935] Oops: 0010 [#1] PREEMPT SMP 
> [   35.299667] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/idVendor
> [   35.300328] CPU 0 
> [   35.300328] Modules linked in:
> [   35.300328] 
> [   35.300328] Pid: 2481, comm: keymap Not tainted 2.6.34-mmotm0519 #1 0X564R/Latitude E6500                  
> [   35.300328] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
> [   35.300328] RSP: 0018:ffff88011d4d5cb0  EFLAGS: 00010046
> [   35.310163] RAX: 0000000000000000 RBX: ffff88011c03e000 RCX: 0000000000000081
> [   35.310163] RDX: ffff88011d4d5cc4 RSI: ffff88011d4d5cc8 RDI: ffff88011c03e000
> [   35.310163] RBP: ffff88011d4d5d28 R08: ffff88011e9b28e8 R09: 0000000000000001
> [   35.310163] R10: ffffffff81e0b160 R11: 0000000000000004 R12: 00000000000000a4
> [   35.310163] R13: ffff88011c03e830 R14: 0000000000000286 R15: ffff88011d4d5cc8
> [   35.310163] FS:  00007f4b86283700(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
> [   35.319397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   35.319397] CR2: 0000000000000000 CR3: 000000011d575000 CR4: 00000000000406f0
> [   35.319397] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   35.319397] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   35.319397] Process keymap (pid: 2481, threadinfo ffff88011d4d4000, task ffff88011e9b28c0)
> [   35.319397] Stack:
> [   35.319397]  ffffffff813bf3d1 ffff88011d4d5cf8 0000008100000246 00000081000000a4
> [   35.319397] <0> 0000000000000004 0000000000000000 ffff88011d4d5cc4 ffff88011cf11200
> [   35.319397] <0> ffff88011c179000 ffff88011d4d5d28 0000000000000081 00007fff9ee21fa0
> [   35.319397] Call Trace:
> [   35.319397]  [<ffffffff813bf3d1>] ? input_set_keycode+0xad/0x12c
> [   35.319397]  [<ffffffff813c231d>] evdev_do_ioctl+0x22b/0x79b
> [   35.337913]  [<ffffffff815a4b04>] ? __mutex_lock_common+0x564/0x580
> [   35.337913]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.341507]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.341507]  [<ffffffff813c28f0>] evdev_ioctl_handler+0x63/0x80
> [   35.344034]  [<ffffffff813c292a>] evdev_ioctl+0xb/0xd
> [   35.344034]  [<ffffffff810ea6cd>] vfs_ioctl+0x2d/0xa1
> [   35.344034]  [<ffffffff810eac4c>] do_vfs_ioctl+0x494/0x4cd
> [   35.344034]  [<ffffffff810eacdc>] sys_ioctl+0x57/0x95
> [   35.344034]  [<ffffffff8100266b>] system_call_fastpath+0x16/0x1b
> [   35.344034] Code:  Bad RIP value.
> [   35.344034] RIP  [<(null)>] (null)
> [   35.344034]  RSP <ffff88011d4d5cb0>
> [   35.344034] CR2: 0000000000000000
> [   35.357018] ---[ end trace 394fa5aa8a77b6f3 ]---

--==_Exmh_1275332484_6730P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMBAeEcC3lWbTT17ARAqtcAJ9ndlto6WyxyyfdNNn/QoBRYwVxZQCeNdti
3I14q0vxms+A/U24gd0vUnY=
=3zLD
-----END PGP SIGNATURE-----

--==_Exmh_1275332484_6730P--

