Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1D1Img (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:42:36 -0400
Received: from gw3.lbox.cz ([62.245.111.133]:39695 "EHLO pcnci.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932124Ab1D1Ima (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:42:30 -0400
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 04:42:30 EDT
Date: Thu, 28 Apr 2011 10:26:25 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Cc: linux-stable mlist <stable@kernel.org>
Subject: 2.6.32.21 - uptime related crashes?
Message-ID: <20110428082625.GA23293@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody,

I'm trying to solve strange issue, today, my fourth machine running 2.6.32.=
21 just crashed. What makes the cases similar, apart fromn same kernel vers=
ion is that all boxes had very similar uptimes: 214, 216, 216, and 224 days=
=2E This might just be a coincidence, but I think this might be important.

Unfortunately I only have backtraces of two crashes (and those are trimmed,=
 sorry), and they do not look as similar as I'd like, but still maybe there=
 is something in common:

[<ffffffff81120cc7>] pollwake+0x57/0x60=20
[<ffffffff81046720>] ? default_wake_function+0x0/0x10=20
[<ffffffff8103683a>] __wake_up_common+0x5a/0x90=20
[<ffffffff8103a313>] __wake_up+0x43/0x70=20
[<ffffffffa0321573>] process_masterspan+0x643/0x670 [dahdi]=20
[<ffffffffa0326595>] coretimer_func+0x135/0x1d0 [dahdi]=20
[<ffffffff8105d74d>] run_timer_softirq+0x15d/0x320=20
[<ffffffffa0326460>] ? coretimer_func+0x0/0x1d0 [dahdi]=20
[<ffffffff8105690c>] __do_softirq+0xcc/0x220=20
[<ffffffff8100c40c>] call_softirq+0x1c/0x30=20
[<ffffffff8100e3ba>] do_softirq+0x4a/0x80=20
[<ffffffff810567c7>] irq_exit+0x87/0x90=20
[<ffffffff8100d7b7>] do_IRQ+0x77/0xf0=20
[<ffffffff8100bc53>] ret_from_intr+0x0/Oxa=20
<EUI> [<ffffffffa019e556>] ? acpi_idle_enter_bm+0x273/0x2a1 [processor]=20
[<ffffffffa019e54c>] ? acpi_idle_enter_bm+0x269/0x2a1 [processor]=20
[<ffffffff81280095>] ? cpuidle_idle_call+0xa5/0x150=20
[<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90=20
[<ffffffff81323c95>] ? rest_init+0x75/0x80=20
[<ffffffff81582d7f>] ? start_kernel+0x2ef/0x390=20
[<ffffffff81582271>] ? x86_64_start_reservations+0x81/0xc0=20
[<ffffffff81582386>] ? x86_64_start_kernel+0xd6/0x100=20

this box (actually two of the crashed ones) is using dahdi_dummy module to =
generate timing for asterisk SW pbx, so maybe it's related to it.


[<ffffffff810a5063>] handle_IRQ_event+0x63/0x1c0
[<ffffffff810a71ae>] handle_edge_irq+0xce/0x160
[<ffffffff8100e1bf>] handle_irq+0x1f/0x30                                  =
                                                                           =
                                =20
[<ffffffff8100d7ae>] do_IRQ+0x6e/0xf0
[<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
<EUI> [<ffffffff8133?f?f>] ? _spin_un1ock_irq+0xf/0x40
[<ffffffff81337f79>] ? _spin_un1ock_irq+0x9/0x40
[<ffffffff81064b9a>] ? exit_signals+0x8a/0x130
[<ffffffff8105372e>] ? do_exit+0x7e/0x7d0
[<ffffffff8100f8a7>] ? oops_end+0xa7/0xb0
[<ffffffff8100faa6>] ? die+0x56/0x90
[<ffffffff8100c810>] ? do_trap+0x130/0x150
[<ffffffff8100ccca>] ? do_divide_error+0x8a/0xa0
[<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
[<ffffffff8104400b>] ? cpuacct_charge+0x6b/0x90
[<ffffffff8100c045>] ? divide_error+0x15/0x20
[<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
[<ffffffff8103cfff>] ? find_busiest_group+0x1af/0xa00
[<ffffffff81335483>] ? thread_return+0x4ce/0x7bb
[<ffffffff8133bec5>] ? do_nanosleep+0x75/0x30
[<ffffffff810?1?4e>] ? hrtimer_nanosleep+0x9e/0x120
[<ffffffff810?08f0>] ? hrtimer_wakeup+0x0/0x30
[<ffffffff810?183f>] ? sys_nanosleep+0x6f/0x80

another two don't use it. only similarity I see here is that it seems to be=
 IRQ handling related, but both issues don't have anything in common.
Does anybody have an idea on where should I look? Of course I should update=
 all those boxes to (at least) latest 2.6.32.x, and I'll do it for sure, bu=
t still I'd first like to know where the problem was, and if it has been fi=
xed, or how to fix it...
I'd be gratefull for any help...
BR
nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk25JLEACgkQ3xdJJrLygV7gFwCcD6H7MpQF5ZhSQqFhlbGwMY/I
sG0AoIwXKtOo5GgX8l8oivkQhts9jUXT
=o8H+
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
