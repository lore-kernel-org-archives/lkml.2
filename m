Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1BPQRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:17:38 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:54559 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1BPQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:17:34 -0500
Date: Wed, 16 Feb 2011 17:17:28 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG and freeze on cat /proc/tty/driver/serial
Message-ID: <20110216161728.GA8431@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

reading /proc/tty/driver/serial leads to a NULL pointer dereference BUG
and freeze on a serial-console enabled 2.6.35.{4,10,11} and 2.6.37.
2.6.32.28 does fine without BUG and freeze.

Fresh boot 2.6.35.11 into emergency...
# cat /proc/tty/driver/serial
[   73.199568] BUG: unable to handle kernel NULL pointer dereference at 000=
00099
[   73.227373] IP: [<c11a8969>] tty_ldisc_try+0x10/0x35
[   73.227373] *pdpt =3D 0000000036da6001 *pde =3D 0000000000000000=20
[   73.227373] Oops: 0000 [#1] SMP=20
[   73.227373] last sysfs file: /sys/devices/virtual/block/md1/md/level
[   73.227373] Modules linked in: ext2 mbcache aes_i586 aes_generic xts gf1=
28mul dm_crypt raid1 md_mod dm_mirror dm_region_hash dm_log btrfs zlib_defl=
ate crc32c libcrc32c dm_mod usbhid hid sg sr_mod sd_mod cdrom crc_t10dif at=
a_generic uhci_hcd ahci ehci_hcd pata_jmicron libahci firewire_ohci sata_si=
l24 libata firewire_core crc_itu_t floppy usbcore thermal scsi_mod atl1 the=
rmal_sys mii nls_base [last unloaded: scsi_wait_scan]
[   73.227373]=20
[   73.227373] Pid: 857, comm: cat Not tainted 2.6.35.11 #1 P5E-V HDMI/P5E-=
V HDMI
[   73.227373] EIP: 0060:[<c11a8969>] EFLAGS: 00010046 CPU: 3
[   73.227373] EIP is at tty_ldisc_try+0x10/0x35
[   73.227373] EAX: 00000002 EBX: 00000000 ECX: c156779c EDX: 000003fe
[   73.227373] ESI: 00000000 EDI: f6c40000 EBP: 0000009b ESP: f6f39e9c
[   73.227373]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   73.227373] Process cat (pid: 857, ti=3Df6f38000 task=3Df6a05280 task.ti=
=3Df6f38000)
[   73.227373] Stack:
[   73.227373]  c1569a08 f6ccc000 c11c4d9d c1569a08 00000080 f6ccc000 c139d=
488 c1569a08
[   73.227373] <0> f6ccc000 f6c40000 f6f39eec c11c4f76 c11c2b36 00000000 00=
0003f8 c139d482
[   73.227373] <0> 00000000 00000000 f6c40040 c142fae4 0804e3f0 fff77270 c5=
b3a560 c143a444
[   73.227373] Call Trace:
[   73.227373]  [<c11c4d9d>] ? check_modem_status+0x7d/0x170
[   73.227373]  [<c11c4f76>] ? serial8250_get_mctrl+0x5/0x35
[   73.227373]  [<c11c2b36>] ? uart_proc_show+0x134/0x2ea
[   73.227373]  [<c10d077c>] ? seq_read+0x176/0x336
[   73.227373]  [<c10a460f>] ? handle_mm_fault+0xbd5/0xc06
[   73.227373]  [<c10d0606>] ? seq_read+0x0/0x336
[   73.227373]  [<c10efc4d>] ? proc_reg_read+0x55/0x68
[   73.227373]  [<c10efbf8>] ? proc_reg_read+0x0/0x68
[   73.227373]  [<c10bd133>] ? vfs_read+0x7c/0xd7
[   73.227373]  [<c128c475>] ? do_page_fault+0x26d/0x2cf
[   73.227373]  [<c10bd221>] ? sys_read+0x3c/0x60
[   73.227373]  [<c1007d5f>] ? sysenter_do_call+0x12/0x28
[   73.227373] Code: 00 eb ea ff 47 4c 89 fb 89 ea b8 9c 77 56 c1 e8 7c 0e =
0e 00 89 d8 5b 5e 5f 5d c3 56 89 c6 53 b8 9c 77 56 c1 e8 21 0e 0e 00 31 db =
<f6> 86 99 00 00 00 02 74 0b 8b 5e 28 85 db 74 04 f0 ff 43 04 89=20
[   73.227373] EIP: [<c11a8969>] tty_ldisc_try+0x10/0x35 SS:ESP 0068:f6f39e=
9c
[   73.227373] CR2: 0000000000000099
[   73.227373] ---[ end trace d434316c12adce41 ]---

2.6.37 doesn't print a full trace before freezing but only the first two
lines or less.

Either disabling the serial console or running setserial -g on the
serial console port avoids the BUG and the freeze:

Fresh boot 2.6.35.11 into emergency...
# setserial -g /dev/ttyS0
/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
# cat /proc/tty/driver/serial=20
serinfo:1.0 driver revision:
0: uart:16550A port:000003F8 irq:4 tx:0 rx:0 CTS|DTR|CD
1: uart:unknown port:000002F8 irq:3
2: uart:unknown port:000003E8 irq:4
3: uart:unknown port:000002E8 irq:3
4: uart:16550A port:0000EC00 irq:17 tx:0 rx:0
5: uart:16550A port:0000E880 irq:17 tx:0 rx:0 CTS|CD
6: uart:16550A port:0000E800 irq:17 tx:0 rx:0
7: uart:16550A port:0000E480 irq:17 tx:0 rx:0
8: uart:16550A port:0000E400 irq:17 tx:0 rx:0
9: uart:16550A port:0000E080 irq:17 tx:0 rx:0
#=20

serial and console related kernel boot messages:
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-2.6.35.11 root=3D=
/dev/mapper/md1 ro console=3DttyS0,38400n8r console=3Dtty0 enable_mtrr_clea=
nup raid=3Dnoautodetect parport=3D0x378,7,3 8250.nr_uarts=3D10 panic=3D60 e=
mergency
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    3.391406] vesafb: framebuffer at 0xd0000000, mapped to 0xf8280000, usi=
ng 3072k, total 3072k
[    3.416943] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D0
[    3.435193] vesafb: scrolling: redraw
[    3.446167] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    3.482257] Console: switching to colour frame buffer device 128x48
[    3.520338] fb0: VESA VGA frame buffer device
[    3.955642] Serial: 8250/16550 driver, 10 ports, IRQ sharing enabled
[    3.974981] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    3.993496] 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.010472] serial 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    4.031637] 0000:05:01.0: ttyS4 at I/O 0xec00 (irq =3D 17) is a 16550A
[    4.050966] 0000:05:01.0: ttyS5 at I/O 0xe880 (irq =3D 17) is a 16550A
[    4.070282] 0000:05:01.0: ttyS6 at I/O 0xe800 (irq =3D 17) is a 16550A
[    4.089608] 0000:05:01.0: ttyS7 at I/O 0xe480 (irq =3D 17) is a 16550A
[    4.108940] 0000:05:01.0: ttyS8 at I/O 0xe400 (irq =3D 17) is a 16550A
[    4.128258] 0000:05:01.0: ttyS9 at I/O 0xe080 (irq =3D 17) is a 16550A


regards
   Mario
--=20
Computer games don't affect kids; I mean if Pac-Man affected us as kids,
we'd all be running around in darkened rooms, munching magic pills and
listening to repetitive electronic music.
                                  -- Kristian Wilson, Nintendo Inc, 1989

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTVv4mBS+e2HeSPbpAQKRsgf9HDoa/T+BSD++Bln0I+0JENmSpriIVEpd
KfBk3cDf17Mob7zSQY4gEL279PzUPMVrKXshUfYKS7Eb5zUEKOYENo2nRjoj3Pjw
BV4zR82Jb/yo2gWy99fnRGvGR1l8UWng4GTfP7IiT1+0MwMYdP2FPNYR1YS7VPzg
vjNo14IV5Hx5xVSOOpo8R9EaX4gxuZCH7OIxPyKVu03y82EaBOXbxVPCkSI5UP47
lNnZvIyxiJUJaFhby+0hUEgB7jZRhdaoVbk4qM78gyWC1n6k7kkfCFQKmoggSIBr
AtbRqtWMHX1keFM8+6tSntixh3vstpn+54gAom6bOjQKLFzu/wLIcg==
=xcER
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
