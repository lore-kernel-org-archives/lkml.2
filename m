Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1EGLP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 07:15:58 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:48572 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1EGLPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 07:15:53 -0400
Date: Sat, 7 May 2011 13:15:47 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, linux-usb@vger.kernel.org, stable@kernel.org
Subject: 2.6.32.28 - BUG: sleeping function called from invalid context at
	kernel/mutex.c:94
Message-ID: <20110507111547.GA3557@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5092150 records (last update: 20110507)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
one more problem I've encountered on 2.6.32.28 after upgrading from 2.6.27.=
x:

[  173.829570] BUG: sleeping function called from invalid context at kernel=
/mutex.c:94
[  173.829575] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
[  173.829580] Pid: 0, comm: swapper Not tainted 2.6.32lb.32 #1
[  173.829583] Call Trace:
[  173.829585]  <IRQ>  [<ffffffff8103a746>] __might_sleep+0xe6/0x100
[  173.829601]  [<ffffffff8133871f>] mutex_lock+0x1f/0x50
[  173.829607]  [<ffffffff81211ca0>] tty_unthrottle+0x20/0x60
[  173.829614]  [<ffffffffa069fd01>] ppp_asynctty_receive+0x1d1/0x510 [ppp_=
async]
[  173.829618]  [<ffffffff8121409a>] flush_to_ldisc+0x16a/0x1d0
[  173.829622]  [<ffffffff81214155>] tty_flip_buffer_push+0x55/0x80
[  173.829645]  [<ffffffffa02c8c9c>] put_rxbuf_data+0xac/0x160 [hso]
[  173.829651]  [<ffffffffa02c8e01>] put_rxbuf_data_and_resubmit_bulk_urb+0=
x31/0x70 [hso]
[  173.829657]  [<ffffffffa02c8f5c>] hso_std_serial_read_bulk_callback+0x8c=
/0x1b0 [hso]
[  173.829663]  [<ffffffff812479be>] usb_hcd_giveback_urb+0x5e/0xe0
[  173.829680]  [<ffffffffa00012db>] ehci_urb_done+0x8b/0xe0 [ehci_hcd]
[  173.829687]  [<ffffffffa00013d4>] qh_completions+0xa4/0x4a0 [ehci_hcd]
[  173.829694]  [<ffffffffa0002272>] ehci_work+0x92/0x9c0 [ehci_hcd]
[  173.829698]  [<ffffffff81339d7c>] ? _spin_unlock_bh+0x1c/0x20
[  173.829703]  [<ffffffffa069f4bc>] ? ppp_async_push+0x23c/0x4c0 [ppp_asyn=
c]
[  173.829710]  [<ffffffffa00061dc>] ehci_irq+0x15c/0x1f0 [ehci_hcd]
[  173.829715]  [<ffffffff812493d8>] usb_hcd_irq+0x38/0x80
[  173.829720]  [<ffffffff810a5753>] handle_IRQ_event+0x63/0x1c0
[  173.829725]  [<ffffffff810a79b5>] handle_fasteoi_irq+0x85/0x110
[  173.829729]  [<ffffffff8100e1bf>] handle_irq+0x1f/0x30
[  173.829733]  [<ffffffff8100d7ae>] do_IRQ+0x6e/0xf0
[  173.829738]  [<ffffffff8100bc53>] ret_from_intr+0x0/0xa
[  173.829740]  <EOI>  [<ffffffff810139ae>] ? mwait_idle+0x6e/0xe0
[  173.829748]  [<ffffffff8101396c>] ? mwait_idle+0x2c/0xe0
[  173.829752]  [<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90
[  173.829756]  [<ffffffff813259d5>] ? rest_init+0x75/0x80
[  173.829762]  [<ffffffff81584d7f>] ? start_kernel+0x2ef/0x390
[  173.829766]  [<ffffffff81584271>] ? x86_64_start_reservations+0x81/0xc0
[  173.829770]  [<ffffffff81584386>] ? x86_64_start_kernel+0xd6/0x100
[  173.829773] ------------[ cut here ]------------

[  173.833556] WARNING: at kernel/mutex.c:214 __mutex_lock_slowpath+0x2d9/0=
x310()
[  173.833556] Hardware name: PDSMi-LN4
[  173.833556] Modules linked in: ppp_async crc_ccitt ipmi_si ipmi_devintf =
ipmi_msghandler ppp_generic slhc ipt_REDIRECT xt_tcpudp xt_conntrack xt_com=
ment ipt_REJECT xt_multiport xt_policy xt_state nf_nat_ftp nf_conntrack_ftp=
 iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag=
_ipv4 iptable_filter ip_tables ipt_ULOG x_tables deflate zlib_deflate ctr t=
wofish twofish_common camellia serpent blowfish cast5 des_generic cbc crypt=
d crypto_wq aes_x86_64 aes_generic xcbc rmd160 sha256_generic sha1_generic =
md5 hmac cryptomgr aead pcompress crypto_null crypto_blkcipher crypto_hash =
crypto_algapi af_key autofs4 lockd sunrpc 8021q bonding ipv6 reiserfs video=
 backlight output sbs sbshc fan battery ac parport_pc lp parport nvram cont=
ainer hso rfkill usbhid sg e1000e piix thermal processor button thermal_sys=
 i3000_edac rng_core iTCO_wdt tpm_tis tpm tpm_bios i2c_i801 edac_core i2c_c=
ore shpchp pci_hotplug pcspkr ahci pata_acpi ide_pci_generic ide_core ata_p=
iix ata_generic libata sd_mod scsi_mod crc_t10dif raid1 dm_snapshot dm_zero=
 dm_mirror dm_region_hash dm_log dm_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd=
 [last unloaded: scsi_wait_scan]
[  173.920445] Pid: 0, comm: swapper Not tainted 2.6.32lb.32 #1
[  173.920445] Call Trace:
[  173.920445]  <IRQ>  [<ffffffff813386c9>] ? __mutex_lock_slowpath+0x2d9/0=
x310
[  173.920445]  [<ffffffff81050207>] warn_slowpath_common+0x87/0xb0
[  173.920445]  [<ffffffff8105023f>] warn_slowpath_null+0xf/0x20
[  173.920445]  [<ffffffff813386c9>] __mutex_lock_slowpath+0x2d9/0x310
[  173.920445]  [<ffffffff81338727>] mutex_lock+0x27/0x50
[  173.920445]  [<ffffffff81211ca0>] tty_unthrottle+0x20/0x60
[  173.920445]  [<ffffffffa069fd01>] ppp_asynctty_receive+0x1d1/0x510 [ppp_=
async]
[  173.920445]  [<ffffffff8121409a>] flush_to_ldisc+0x16a/0x1d0
[  173.920445]  [<ffffffff81214155>] tty_flip_buffer_push+0x55/0x80
[  173.920445]  [<ffffffffa02c8c9c>] put_rxbuf_data+0xac/0x160 [hso]
[  173.920445]  [<ffffffffa02c8e01>] put_rxbuf_data_and_resubmit_bulk_urb+0=
x31/0x70 [hso]
[  173.920445]  [<ffffffffa02c8f5c>] hso_std_serial_read_bulk_callback+0x8c=
/0x1b0 [hso]
[  173.920445]  [<ffffffff812479be>] usb_hcd_giveback_urb+0x5e/0xe0
[  173.920445]  [<ffffffffa00012db>] ehci_urb_done+0x8b/0xe0 [ehci_hcd]
[  173.920445]  [<ffffffffa00013d4>] qh_completions+0xa4/0x4a0 [ehci_hcd]
[  173.920445]  [<ffffffffa0002272>] ehci_work+0x92/0x9c0 [ehci_hcd]
[  173.920445]  [<ffffffff81339d7c>] ? _spin_unlock_bh+0x1c/0x20
[  173.920445]  [<ffffffffa069f4bc>] ? ppp_async_push+0x23c/0x4c0 [ppp_asyn=
c]
[  173.920445]  [<ffffffffa00061dc>] ehci_irq+0x15c/0x1f0 [ehci_hcd]
[  173.920445]  [<ffffffff812493d8>] usb_hcd_irq+0x38/0x80
[  173.920445]  [<ffffffff810a5753>] handle_IRQ_event+0x63/0x1c0
[  173.920445]  [<ffffffff810a79b5>] handle_fasteoi_irq+0x85/0x110
[  173.920445]  [<ffffffff8100e1bf>] handle_irq+0x1f/0x30
[  173.920445]  [<ffffffff8100d7ae>] do_IRQ+0x6e/0xf0
[  173.920445]  [<ffffffff8100bc53>] ret_from_intr+0x0/0xa
[  173.920445]  <EOI>  [<ffffffff810139ae>] ? mwait_idle+0x6e/0xe0
[  173.920445]  [<ffffffff8101396c>] ? mwait_idle+0x2c/0xe0
[  173.920445]  [<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90
[  173.920445]  [<ffffffff813259d5>] ? rest_init+0x75/0x80
[  173.920445]  [<ffffffff81584d7f>] ? start_kernel+0x2ef/0x390
[  173.920445]  [<ffffffff81584271>] ? x86_64_start_reservations+0x81/0xc0
[  173.920445]  [<ffffffff81584386>] ? x86_64_start_kernel+0xd6/0x100
[  173.920445] ---[ end trace 21042040f8c942e6 ]---

It doesn't seem to be causing anything horrible, but it would be fine to ha=
ve it fixed anyway :)
If I could provide further testing or information, I'll be glad to do so.
cheers!
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

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3FKeMACgkQ3xdJJrLygV5WtQCffBodAOlLFQxofSkOi7cZ030X
k4MAoKbulul0GugPJH1Zyw6t4cXb4uxK
=Wo7E
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
