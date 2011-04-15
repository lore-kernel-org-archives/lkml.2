Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1DOS4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:56:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33251 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1DOS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:56:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-04-14 - hangs during boot.
In-Reply-To: Your message of "Fri, 15 Apr 2011 10:57:09 EDT."
             <9629.1302879429@localhost>
From: Valdis.Kletnieks@vt.edu
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
            <9629.1302879429@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302893631_5065P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Apr 2011 14:53:51 -0400
Message-ID: <6325.1302893631@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DA89442.0014,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302893631_5065P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Apr 2011 10:57:09 EDT, Valdis.Kletnieks=40vt.edu said:
> On Thu, 14 Apr 2011 15:08:47 PDT, akpm=40linux-foundation.org said:
> > The mm-of-the-moment snapshot 2011-04-14-15-08 has been uploaded to
> >=20
> >    http://userweb.kernel.org/=7Eakpm/mmotm/
>=20
> This throws at least two complaints about lockdep on the way up.  I've =
had
> several complete hangs as well last night during boot=20

Caught them.  Not sure how the WARN_ON_ONCE it's hitting just before it h=
angs
is related to the actual hang, but I'm betting it's the kernel's last pla=
intive
cry for help before everything grinds to a halt.

First boot:

=5B    3.852927=5D input: PS/2 Generic Mouse as /devices/platform/i8042/s=
erio1/input/input10
=5B    3.859723=5D ------------=5B cut here =5D------------
=5B    3.859859=5D WARNING: at kernel/workqueue.c:1217 worker_enter_idle+=
0x168/0x19f()
=5B    3.859984=5D Hardware name: Latitude E6500
=5B    3.860089=5D Modules linked in:
=5B    3.860308=5D Pid: 11, comm: kworker/1:0 Not tainted 2.6.39-rc3-mmot=
m0414 =231
=5B    3.860428=5D Call Trace:
=5B    3.860531=5D  =5B<ffffffff81037c62>=5D warn_slowpath_common+0x7e/0x=
96
=5B    3.860640=5D  =5B<ffffffff81037c8f>=5D warn_slowpath_null+0x15/0x17=

=5B    3.860677=5D  =5B<ffffffff8104e12d>=5D worker_enter_idle+0x168/0x19=
f
=5B    3.860677=5D  =5B<ffffffff81050d3f>=5D worker_thread+0x1ed/0x206
=5B    3.860677=5D  =5B<ffffffff81050b52>=5D ? manage_workers+0xc0/0xc0
=5B    3.860677=5D  =5B<ffffffff8105472e>=5D kthread+0x7f/0x87
=5B    3.860677=5D  =5B<ffffffff8156bb94>=5D kernel_thread_helper+0x4/0x1=
0
=5B    3.860677=5D  =5B<ffffffff81564d84>=5D ? retint_restore_args+0xe/0x=
e
=5B    3.860677=5D  =5B<ffffffff810546af>=5D ? __init_kthread_worker+0x55=
/0x55
=5B    3.860677=5D  =5B<ffffffff8156bb90>=5D ? gs_change+0xb/0xb
=5B    3.860677=5D ---=5B end trace 64d29d8be7ad450b =5D---

and wham it was dead hard at that point,no further output.  Next boot, it=
 hit again,
and lived a while longer:

=5B    3.983798=5D input: PS/2 Generic Mouse as /devices/platform/i8042/s=
erio1/input/input10
=5B    3.993411=5D ------------=5B cut here =5D------------
=5B    3.993531=5D WARNING: at kernel/workqueue.c:1217 worker_enter_idle+=
0x168/0x19f()
=5B    3.993658=5D Hardware name: Latitude E6500
=5B    3.993764=5D Modules linked in:
=5B    3.993951=5D Pid: 482, comm: kworker/1:1 Not tainted 2.6.39-rc3-mmo=
tm0414 =231
=5B    3.994065=5D Call Trace:
=5B    3.994173=5D  =5B<ffffffff81037c62>=5D warn_slowpath_common+0x7e/0x=
96
=5B    3.994282=5D  =5B<ffffffff81037c8f>=5D warn_slowpath_null+0x15/0x17=

=5B    3.994381=5D  =5B<ffffffff8104e12d>=5D worker_enter_idle+0x168/0x19=
f
=5B    3.994381=5D  =5B<ffffffff81050d3f>=5D worker_thread+0x1ed/0x206
=5B    3.994381=5D  =5B<ffffffff81050b52>=5D ? manage_workers+0xc0/0xc0
=5B    3.994381=5D  =5B<ffffffff8105472e>=5D kthread+0x7f/0x87
=5B    3.994381=5D  =5B<ffffffff8156bb94>=5D kernel_thread_helper+0x4/0x1=
0
=5B    3.994381=5D  =5B<ffffffff81564d84>=5D ? retint_restore_args+0xe/0x=
e
=5B    3.994381=5D  =5B<ffffffff810546af>=5D ? __init_kthread_worker+0x55=
/0x55
=5B    3.994381=5D  =5B<ffffffff8156bb90>=5D ? gs_change+0xb/0xb
=5B    3.994381=5D ---=5B end trace 604fcd3646d16bcd =5D---
=5B    4.141467=5D udevadm used greatest stack depth: 4352 bytes left
=5B    4.225220=5D usb 1-4.1: new low speed USB device number 5 using ehc=
i_hcd
=5B    4.326710=5D usb 1-4.1: New USB device found, idVendor=3D045e, idPr=
oduct=3D0023
=5B    4.326831=5D usb 1-4.1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B    4.326959=5D usb 1-4.1: Product: Microsoft Trackball Optical=C2=AE
=5B    4.327105=5D usb 1-4.1: Manufacturer: Microsoft
=5B    4.338620=5D input: Microsoft Microsoft Trackball Optical=C2=AE as =
/devices/pci0000:00/0000:00:1a.7/sb1/1-4/1-4.1/1-4.1:1.0/input/input11
=5B    4.339775=5D generic-usb 0003:045E:0023.0001: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Micr
osoft Trackball Optical=C2=AE=5D on usb-0000:00:1a.7-4.1/input0
=5B    4.413229=5D usb 1-4.2: new full speed USB device number 6 using eh=
ci_hcd
=5B    4.467320=5D dracut: luksOpen /dev/sda2 luks-715ceabf-6f58-4251-937=
3-ed29e8629a7c
=5B    4.498856=5D usb 1-4.2: New USB device found, idVendor=3D0451, idPr=
oduct=3D1446
=5B    4.498998=5D usb 1-4.2: New USB device strings: Mfr=3D0, Product=3D=
0, SerialNumber=3D0
=5B    4.500490=5D hub 1-4.2:1.0: USB hub found
=5B    4.500704=5D hub 1-4.2:1.0: 4 ports detected
=5B    4.707088=5D usb 5-1: new full speed USB device number 2 using uhci=
_hcd
=5B    4.875565=5D usb 5-1: New USB device found, idVendor=3D0a5c, idProd=
uct=3D5800
=5B    4.875684=5D usb 5-1: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D3
=5B    4.875805=5D usb 5-1: Product: 5880

but it then didn't accept keyboard input from the USB keyboard and acted =
pretty dead.

Any ideas, or am I looking at a weekend of bisecting? ;)



--==_Exmh_1302893631_5065P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqJQ/cC3lWbTT17ARAt8LAJ9rnm0X5Jxw+/NQqU1bWRIFEKXsEwCdGJMY
D1e1C0EJPTh8oEjViYE60pc=
=Ist+
-----END PGP SIGNATURE-----

--==_Exmh_1302893631_5065P--

