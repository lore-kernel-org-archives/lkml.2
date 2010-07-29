Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0G2JP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:15:27 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:34389 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0G2JPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:15:24 -0400
Date: Thu, 29 Jul 2010 11:15:17 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Regression 2.6.35-rc6: ALSA Intel HDA/Realtek:
 missing	Beep
Message-ID: <20100729091517.GA8902@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <20100728144903.GA18170@darkside.kls.lan>
 <s5hzkxbtya9.wl%tiwai@suse.de>
 <s5htynjtwz2.wl%tiwai@suse.de>
 <20100728212745.GA15394@darkside.kls.lan>
 <s5hd3u6alkp.wl%tiwai@suse.de>
 <20100729080930.GA20619@darkside.kls.lan>
 <s5h7hkeae35.wl%tiwai@suse.de>
 <20100729084138.GA15456@darkside.kls.lan>
 <s5h39v2acvf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <s5h39v2acvf.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2010 at 10:52:36AM +0200, Takashi Iwai wrote:
> Usually the codec SSID isn't checked in other places, so passing a
> bogus value should be OK.  Pass a value like 2:

Mh, 1 probably :)

$ cat /etc/modprobe.d/local-alsa.conf=20
options snd-hda-intel model=3Dasus-p5q
install snd-hda-intel /sbin/modprobe --ignore-install snd-hda-intel $CMDLIN=
E_OPTS && { cd /sys/class/sound/hwC0D0; echo -n 1 > subsystem_id; echo -n 1=
 > reconfig; : ; }

Yep, Beep is back :)

Btw...

On Thu, Jul 29, 2010 at 10:26:22AM +0200, Takashi Iwai wrote:
> So, the fix is likely to override SSID value, or create a special
> quirk rule to enable PC-beep for known white-list, supposing BIOS
> won't be fixed in any future...

Well, the Board is from 2007, the last BIOS is from Aug 2009. I don't
think Asus will provide an update just for that :)


Thanks for your help
   Mario
--=20
Unfortunately, the chip vendors have delayed the availability of the
long-promised crystal-ball peripherals yet again, forcing the governor
code to rely on heuristics; once again, software must make up for
deficiencies in the hardware.                  -- Jonathan Corbet, LWN

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTFFGpRS+e2HeSPbpAQLGsQf/dAsW94fg4LqJkoh8tAuAL0Hdj/LrD7BJ
wO3pBQgcfad40KUEVxWTKrelou0HRYWFamZbeOcbjO2sLBKyP8P4ITD3vaT+U746
aG3P1AEGGu22+S0DOldGZY/oRSAqF/ldkNeqb2Han4yGhFj5mJWhpJrPV1IUgFG6
96MsKC1i8w4ksyVNu35Vcmeb/eVWbc0MKKJCDKPun1ExogBwv9135gpKxeuP4kbw
WMeR4TL6CVkOojvvKyonE2ejPjVov8j4CpPv1zoaGYQEtNaIYUhie5tvL0vDp0Mf
DcgHe0Jk6MEqywSUlEuUyHSZVhenq4139KKVCtGdnrUCPOwIL7eIEg==
=cUhG
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
