Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2L3MBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 07:01:34 -0500
Received: from vdsl.uvw.ru ([178.79.155.71]:37374 "EHLO vdsl.uvw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab2L3MBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 07:01:31 -0500
X-Greylist: delayed 2451 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2012 07:01:31 EST
Date: Sun, 30 Dec 2012 15:20:32 +0400
From: "Dmitry E. Oboukhov" <unera@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20121230112032.GB5756@vdsl.uvw.ru>
References: <20121230090621.GA5756@vdsl.uvw.ru>
 <20121230103948.GA8650@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <20121230103948.GA8650@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: dimka@vdsl.uvw.ru
Subject: Re: 3.7.1 doesn't go to suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on vdsl.uvw.ru)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>> Hi, Linux maintainers!
>>=20
>> First of all sorry for my bad English.
>>=20
>> I have Macbook Pro Retina and used Linux-3.7rc7 with the book.
>> It worked fine.
>>=20
>> Today I've tried to migrate to 3.7.1 (from debian repo) and found that
>> current kernel can't suspend.
>>=20
>> If I call pm-suspend in my shell, my computer doesn't go to suspend
>> and dmesg showes the error:
>>=20
>> [ 2512.960666] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37 [s=
nd_hda_intel] returns -11
>>=20
>>=20
>> 3.7rc7 worked fine.
>>=20
>>=20
>> In attaches You can find some /proc/* files

> You may want to rmmod snd_hda_inte before suspend and see if it helps?

Hi!
After rmmodding snd_hda_intel pm-suspend doesn't work yet.

nb:[~]$ sudo rmmod snd_hda_intel=20
nb:[~]$ sudo rmmod snd_hda_codec_cirrus snd_hda_codec_hdmi
snd_hda_codec
nb:[~]$ sudo rmmod snd_timer=20
Error: Module snd_timer is in use by: snd_pcm snd_seq
nb:[~]$ sudo rmmod snd_pcm snd_seq snd_timer=20
nb:[~]$ sudo rmmod snd_seq_device=20
nb:[~]$ sudo rmmod snd_hwdep=20
nb:[~]$ sudo rmmod snd_page_alloc=20
nb:[~]$ sudo pm-suspend
nb:[~]$ dmesg|tail
[   30.266443] wlan0: associated
[   30.266463] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes
ready
[   30.342137] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[   30.352607] lp: driver loaded but no devices found
[   30.358793] ppdev: user-space parallel port driver
[   30.425092] nouveau W[  PGRAPH][0000:01:00.0] disabled, PGRAPH=3D1 to
enable
[   30.778659] bcm5974: bad trackpad package, length: 8
[   32.490108] input: Mouseemu virtual keyboard as
/devices/virtual/input/input19
[   32.490441] input: Mouseemu virtual mouse as
/devices/virtual/input/input20
[   65.112500] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11



Also dmesg complains about the modules until booting process is done:
nb:[~]$ dmesg|grep suspend
[   26.331831] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[   30.342137] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11
[   65.112500] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11




3.7rc7 works fine.

PPS: I've just rebooted into 3.7rc7.
its dmesg complains while booting, too:

nb:[~]$ dmesg|grep suspend
[   31.759388] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x37
[snd_hda_intel] returns -11

but it complains once and then it suspends/wakeups/plays sounds fine
:)



--=20

=2E ''`.                               Dmitry E. Oboukhov
: :=E2=80=99  :   email: unera@debian.org jabber://UNera@uvw.ru
`. `~=E2=80=99              GPGKey: 1024D / F8E26537 2006-11-21
  `- 1B23 D4F8 8EC0 D902 0555  E438 AB8C 00CF F8E2 6537

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAlDgI4AACgkQq4wAz/jiZTe3LgCfTSLzd/wYGUexEKnzwjRrIa8L
cfoAn0K/rg5Cy8mDj8ak1IIHzc20C28R
=Wamk
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
