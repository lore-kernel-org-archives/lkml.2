Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1KKU7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 15:59:00 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56130 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1KKU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 15:58:59 -0500
Date: Fri, 11 Nov 2011 21:58:45 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: bttv: tuner doesn't work for radio
Message-ID: <20111111215845.50ccf920@x220>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nJx1lyVgYqvn8iVZlMg2DT+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nJx1lyVgYqvn8iVZlMg2DT+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

I have a Hauppauge Bt878 card with radio tuner. Recent kernels can switch
between TV channels, but the tuner fails for radio. If no channel had been
previously selected, choosing a radio program yields white noise. Otherwise,
if a TV channel was previously selected, I can always hear the previous TV
channel audio, no matter what radio station I tune to.

I've bisected the problem. The commit that breaks things is:

commit cbde689823776d187ba1b307a171625dbc02dd4f
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Fri Feb 4 10:42:09 2011 -0300

    [media] tuner-core: Better implement standby mode
   =20
    In the past, T_STANDBY were used on devices with a separate radio tuner=
 to
    mark a tuner that were disabled. With the time, it got newer meanings.
   =20
    Also, due to a bug at the logic, the driver might incorrectly return
    T_STANDBY to userspace.
   =20
    So, instead of keeping the abuse, just use a boolean for storing
    such information.
   =20
    We can't remove T_STANDBY yet, as this is used on two other drivers. A
    latter patch will address its usage outside tuner-core.
   =20
    Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

This is the relevant dmesg output of a kernel one commit before the breakag=
e.

Linux video capture interface: v2.00
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
i2c-core: driver [msp3400] using legacy suspend method
i2c-core: driver [msp3400] using legacy resume method
bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
bttv0: detected: Hauppauge WinTV [card=3D10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=3D10,autodetected]
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 16-0050: Hauppauge model 37284, rev B221, serial# 3546046
tveeprom 16-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 16-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 16-0050: audio processor is MSP3410D (idx 5)
tveeprom 16-0050: has radio
bttv0: Hauppauge eeprom indicates model#37284
bttv0: tuner type=3D5
msp3400 16-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
msp3400 16-0040: msp3400 supports nicam, mode is autodetect
tuner 16-0042: chip found @ 0x84 (bt878 #0 [sw])
tda9887 16-0042: creating new instance
tda9887 16-0042: tda988[5/6/7] found
tuner 16-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 16-0061: creating new instance
tuner-simple 16-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles=
))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 =3D> 35468950 .. ok

Please let me know if I can help getting this fixed, e.g. by testing patche=
s.

Cheers,

	- Udo

--Sig_/nJx1lyVgYqvn8iVZlMg2DT+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk69jIUACgkQnhRzXSM7nSnNVACffql+F92/KBiy9CbkSl2RjfJS
x1AAn0VpI7i/Y88j26VQDJMLph1K+JMH
=XRNl
-----END PGP SIGNATURE-----

--Sig_/nJx1lyVgYqvn8iVZlMg2DT+--
