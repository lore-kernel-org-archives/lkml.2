Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0G2Ilq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:41:46 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:60157 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0G2Ilo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:41:44 -0400
Date: Thu, 29 Jul 2010 10:41:38 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Regression 2.6.35-rc6: ALSA Intel HDA/Realtek:
 missing	Beep
Message-ID: <20100729084138.GA15456@darkside.kls.lan>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <s5h7hkeae35.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2010 at 10:26:22AM +0200, Takashi Iwai wrote:
> FYI, you can change SSID by writing /sys/class/sound/hwC*D*/subsystem_id
> file.  Then reconfigure the codec via triggering
> /sys/class/sound/hwC*D*/reconfig.

Great, that's what I meant with "Or am I somehow able to tweak it? Is
there a module parameter to set this SSID bit?" :)

$ for i in /sys/class/sound/hwC*D*/subsystem_id; do echo "$i: $(cat $i)"; d=
one  =20
/sys/class/sound/hwC0D0/subsystem_id: 0x1043829f
/sys/class/sound/hwC0D1/subsystem_id: 0xffffffff

So, obviously the first check in
	if (ass !=3D codec->bus->pci->subsystem_device && (ass & 1))
is false. How can I tweak the subsystem_id least-invasive not to match
codec->bus->pci->subsystem_device (which should be 0x829f then) anymore?


Mario
--=20
Gib einem Hungrigen einen Fisch, und er ist fuer einen Tag satt.
Zeig ihm, wie man angelt, und er poebelt Dich an, dass er besseres
zu tun haette, als Schnuere ins Wasser haengen zu lassen.
                              -- David Kastrup in de.comp.text.tex

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTFE+whS+e2HeSPbpAQK8ywf/XN44CPUwpYF3pW2xkmjXqOAA4llZ7ab2
6nzMCHEzfWOXxv8OTHBob6t5BXFl9xIGIxsatfdcXuAsHQ9p+Fe8biJ1xHz3On5L
TFAQBE86bls7VZlqa2DOYr16qrrM3gfEKWD60T8R5bbVXFvIIzS7d1+Nl7d7OtoF
UuJnBlRw7slcMCGZU6EWzMtG+z2mU9ULUytWDBI4a78m4IpyjjKvtXlu/K1kz/fm
MqwYk7iFFEkDSdNYv5wWNyjY4m/XBUjXAF0THp9tq75sldVzogAlwmIQuMoJdmrR
dq8g1ry7hBa8eQrStprVWzNU30KNyom0swESXdQ0Hnusv7RKoHgAXg==
=6WOB
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
