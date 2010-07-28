Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab0G1FdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:33:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58444 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0G1FdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:33:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: mmotm 2010-07-27 - WARNING in ec_parse_io_ports()
In-Reply-To: Your message of "Tue, 27 Jul 2010 14:56:50 PDT."
             <201007272226.o6RMQRBm008735@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201007272226.o6RMQRBm008735@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280295051_4558P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jul 2010 01:30:51 -0400
Message-ID: <10677.1280295051@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4C4FC094.0126,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280295051_4558P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Jul 2010 14:56:50 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-07-27-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Seen during very early boot:

[    0.302450] ------------[ cut here ]------------
[    0.302458] WARNING: at drivers/acpi/ec.c:864 ec_parse_io_ports+0x7d/0x110()
[    0.302460] Hardware name: Latitude E6500
[    0.302462] Could not request EC data io port 2352
[    0.302464] Modules linked in:
[    0.302469] Pid: 1, comm: swapper Not tainted 2.6.35-rc6-mmotm0727 #1
[    0.302471] Call Trace:
[    0.302476]  [<ffffffff81037551>] warn_slowpath_common+0x80/0x98
[    0.302481]  [<ffffffff810375fd>] warn_slowpath_fmt+0x41/0x43
[    0.302485]  [<ffffffff8103edff>] ? __request_region+0x94/0x141
[    0.302489]  [<ffffffff8124489a>] ec_parse_io_ports+0x7d/0x110
[    0.302493]  [<ffffffff8124481d>] ? ec_parse_io_ports+0x0/0x110
[    0.302498]  [<ffffffff8125f201>] acpi_walk_resources+0x7d/0xce
[    0.302502]  [<ffffffff812447be>] ec_parse_device+0x41/0xa0
[    0.302505]  [<ffffffff81244be2>] acpi_ec_add+0x81/0x10b
[    0.302509]  [<ffffffff81241b36>] acpi_device_probe+0x4b/0x11d
[    0.302515]  [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[    0.302519]  [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[    0.302523]  [<ffffffff8130a8da>] ? __driver_attach+0x0/0x6b
[    0.302527]  [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[    0.302531]  [<ffffffff8130a505>] driver_attach+0x19/0x1b
[    0.302535]  [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[    0.302539]  [<ffffffff8130ab80>] driver_register+0xb5/0x122
[    0.302544]  [<ffffffff81b4b8d9>] ? acpi_init+0x0/0xe4
[    0.302548]  [<ffffffff812421cf>] acpi_bus_register_driver+0x3e/0x40
[    0.302552]  [<ffffffff81b4bdf7>] acpi_ec_init+0x10/0x1c
[    0.302555]  [<ffffffff81b4b9a8>] acpi_init+0xcf/0xe4
[    0.302560]  [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[    0.302564]  [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[    0.302569]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[    0.302574]  [<ffffffff81595d80>] ? restore_args+0x0/0x30
[    0.302578]  [<ffffffff81b2cb76>] ? kernel_init+0x0/0x1c2
[    0.302581]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
[    0.302662] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.302666] ------------[ cut here ]------------
[    0.302669] WARNING: at drivers/acpi/ec.c:870 ec_parse_io_ports+0xf8/0x110()
[    0.302672] Hardware name: Latitude E6500
[    0.302674] Could not request EC command io port 2356
[    0.302676] Modules linked in:
[    0.302679] Pid: 1, comm: swapper Tainted: G        W   2.6.35-rc6-mmotm0727 #1
[    0.302681] Call Trace:
[    0.302685]  [<ffffffff81037551>] warn_slowpath_common+0x80/0x98
[    0.302689]  [<ffffffff810375fd>] warn_slowpath_fmt+0x41/0x43
[    0.302694]  [<ffffffff8103edff>] ? __request_region+0x94/0x141
[    0.302697]  [<ffffffff81244915>] ec_parse_io_ports+0xf8/0x110
[    0.302701]  [<ffffffff8124481d>] ? ec_parse_io_ports+0x0/0x110
[    0.302705]  [<ffffffff8125f201>] acpi_walk_resources+0x7d/0xce
[    0.302709]  [<ffffffff812447be>] ec_parse_device+0x41/0xa0
[    0.302713]  [<ffffffff81244be2>] acpi_ec_add+0x81/0x10b
[    0.302717]  [<ffffffff81241b36>] acpi_device_probe+0x4b/0x11d
[    0.302721]  [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[    0.302725]  [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[    0.302729]  [<ffffffff8130a8da>] ? __driver_attach+0x0/0x6b
[    0.302733]  [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[    0.302737]  [<ffffffff8130a505>] driver_attach+0x19/0x1b
[    0.302741]  [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[    0.302745]  [<ffffffff8130ab80>] driver_register+0xb5/0x122
[    0.303006]  [<ffffffff81b4b8d9>] ? acpi_init+0x0/0xe4
[    0.303010]  [<ffffffff812421cf>] acpi_bus_register_driver+0x3e/0x40
[    0.303014]  [<ffffffff81b4bdf7>] acpi_ec_init+0x10/0x1c
[    0.303017]  [<ffffffff81b4b9a8>] acpi_init+0xcf/0xe4
[    0.303021]  [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[    0.303025]  [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[    0.303029]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[    0.303033]  [<ffffffff81595d80>] ? restore_args+0x0/0x30
[    0.303037]  [<ffffffff81b2cb76>] ? kernel_init+0x0/0x1c2
[    0.303040]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
[    0.303043] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.303088] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930


--==_Exmh_1280295051_4558P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMT8CLcC3lWbTT17ARAm3KAKCflR9UJIKu4QbC2UKL0H1infaZlACgxRPy
UlT3vkQFaMOzvYY0FYPFEE4=
=jAzQ
-----END PGP SIGNATURE-----

--==_Exmh_1280295051_4558P--

