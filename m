Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab1HCNNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:13:37 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:45845 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab1HCNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:13:31 -0400
Date: Wed, 3 Aug 2011 10:13:24 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: linux-kernel@vger.kernel.org
Cc: marc.zyngier@arm.com, manuel.lauss@googlemail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        segoon@openwall.com, richard@nod.at, gregkh@suse.de,
        kay.sievers@vrfy.org
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
Message-ID: <20110803131323.GC2773@nautilus.holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As Marc Zyngier has pointed out, the culprit is driver_init, which
calls devices_init. I'd say other calls from driver_init also call into
kset and kobject, which will dispatch uevent helper.

I tried to reproduce the problem using UML and only was successful after
setting CONFIG_UEVENT_HELPER_PATH. I guess we could obsolete this
feature and plan its removal soon. Is anybody still using this?

Regards,
Cascardo.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOOUlzAAoJEEWxSg7udFZIjOQQAI+Fjj5qFjye7lz1d6/xPLN7
DqPyHXdMWQ5U6vQrFewamtLkA8hagZA9Pgjk72Q6oCQkbDCKO0wdwDfz8/ZhGtYq
VC6DgCzm9NzK9fpAJ7Dxnj+o4fub7aS9PqYXd3DuxxY1GY4yPAutHmF0ZYzO/KAn
VPBp/vWwsxJAlA6GXA3OCDCHS1Yakaih95I45E2GVNenGV/5+ZyfxZZtZKSr+XWY
0TYyHiOdElDNTGqX4XS2rg6ARB1yH/NQR8C96uY+LEYII3u1mCBP98UReLcvUZLD
9Vbodi54v55js0rDj/xONGNoIhKBVtHCVmgxFfdMMr6GsxS75kIW7VUpfmccmzyR
NAzgv6zbzH8Wy+FlHX5x4bPjnyaiRhDFrIfyK3ltvJ1jqW7VgJCKuYlzJTedy8H/
TnRtCcQnr9VtMg6CYe4qeTJfpfxeMCZLNHoGYPfTGMmSLdp/Rt/z7yNcdmdgakCV
OMTI70c4ND7LmNYp6qYpNGGRI2M74NwXv/evdVqt9KANO3R12XuJ95Git9xKQ9QI
fG0lDpp+/DHFRGnBaVtHApJjQ8RH0miRwKMds2O7gHAcihS/C4UAv2kYThKuvNH9
PMC5c22/TWssvOzGs0C16QTWgufL9rH2Y5IBo4jryHGvc9LZv7gFPaVGTidaASR2
RvWOXcWec8CE5xFd74qD
=/bJI
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
