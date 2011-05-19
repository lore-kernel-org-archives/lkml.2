Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1ESBQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:16:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41277 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab1ESBQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:16:06 -0400
Date: Thu, 19 May 2011 11:15:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: linux-next: build failure after merge of the sound tree
Message-Id: <20110519111557.f147fc1e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_May_2011_11_15_57_+1000_/H0icm5ngUg=3.qM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_May_2011_11_15_57_+1000_/H0icm5ngUg=3.qM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the sound tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

sound/core/pcm_lib.c:333:40: error: macro "xrun_log" passed 3 arguments, bu=
t takes just 2
sound/core/pcm_lib.c: In function 'snd_pcm_update_hw_ptr0':
sound/core/pcm_lib.c:333: error: 'xrun_log' undeclared (first use in this f=
unction)

Caused by commit ec08b14483de ("ALSA: sound, core, pcm_lib: xrun_log: log
also in_interrupt").  This build has CONFIG_SND_PCM_XRUN_DEBUG unset.

Please, please, use grep or some search when making API changes.

I have used the sound tree from next-20110518 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_May_2011_11_15_57_+1000_/H0icm5ngUg=3.qM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1G9NAAoJEDMEi1NhKgbscUsH/2B2UC7QwU/zJckJVh8Y1CLD
NZYsmIWD/7Xct0tervTQdRUVKm0GamR6VUGzZwq1YyfhJqow4PIKi6FaTKDo/oQh
hfgMz22DfjNPNhHQHalVz542merS7fHAb7zuLQkgxVRooXpiTfC9o7wL9epchn3a
AkudOnJjFBLgMZ5GjOitqgOlNDl93FV/8gUfO8vU/mY4NzWXnwq57VLUFfc06ecG
88KTfQF4IfavOfLS+fjHNjDUUuUYeugTHOgWpY6QZShCLPTuF4IVrj6H4IuILNQe
m2nm5A7kKHj3P3t/9pMJvmg4o1t/uNAV8fJv7gWBcXTegQ4eyrMN/srZRt4D68Q=
=1sBr
-----END PGP SIGNATURE-----

--Signature=_Thu__19_May_2011_11_15_57_+1000_/H0icm5ngUg=3.qM--
