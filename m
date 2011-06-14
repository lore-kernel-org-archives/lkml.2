Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1FNGDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:03:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40709 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1FNGDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:03:19 -0400
Date: Tue, 14 Jun 2011 16:03:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20110614160309.553d1767.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jun_2011_16_03_09_+1000_u1zFz/T9cYunazSk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jun_2011_16_03_09_+1000_u1zFz/T9cYunazSk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/pci/hda/snd-hda-codec-realtek.o: In function `snd_hda_detach_beep_dev=
ice':
(.text+0xb6d0): multiple definition of `snd_hda_detach_beep_device'
sound/pci/hda/snd-hda-codec.o:(.text+0xba0): first defined here
sound/pci/hda/snd-hda-codec-analog.o: In function `snd_hda_detach_beep_devi=
ce':
(.text+0x33e0): multiple definition of `snd_hda_detach_beep_device'
sound/pci/hda/snd-hda-codec.o:(.text+0xba0): first defined here
sound/pci/hda/snd-hda-codec-idt.o: In function `snd_hda_detach_beep_device':
(.text+0x6560): multiple definition of `snd_hda_detach_beep_device'
sound/pci/hda/snd-hda-codec.o:(.text+0xba0): first defined here
sound/pci/hda/snd-hda-codec-conexant.o: In function `snd_hda_detach_beep_de=
vice':
(.text+0x40d0): multiple definition of `snd_hda_detach_beep_device'
sound/pci/hda/snd-hda-codec.o:(.text+0xba0): first defined here

Caused by commit 2308f4add3de ("ALSA: hda - Fix beep_device compilation
warnings").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Jun_2011_16_03_09_+1000_u1zFz/T9cYunazSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9vmdAAoJEDMEi1NhKgbsBKIH/j6i7m+LzopFkrY8D37iSBPh
MeaDJFBqu+v0ZCcnxYyJ6NrZB6TZwq7WDbwcU4Z4MdpevNeNvTibnwhoOkt0o07/
k2aAbRtKXTRCrWHRSPbpuVrm/sqPqTAQR+IBffQDYoEMkal9mU/tkjb1ygOKXTWK
8vUnyAnbezTmIr9ClXItVdFOfos/mxGLym9dT4Pnxv4EaJupc0q3cxMEwxh23oqO
Sc/Z/9GyiSNQdBvrmA0oO6aBP9iT5sFyktZ0cFNMX6TE5OxwI0UMZlCUjod4xxJm
0Os7Pw1ypi/e2gcCBfZlS9m2Hg3Q6UKCvg7GhBtgjvf3sDhCJ/G033oVD12+An4=
=ptgm
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jun_2011_16_03_09_+1000_u1zFz/T9cYunazSk--
