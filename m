Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2LEIdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:33:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61005 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LEIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:33:41 -0500
Date: Wed, 5 Dec 2012 09:33:35 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Message-ID: <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xALgIi/9nrZ9TwTL8gsm3X2KX3mCblbrR35wlDRT/2m
 Jldokk91sdVRZMJO+rJxgGHst/eZIDIMXr7vUwEFkx08v6X+A+
 V4V07GIrNiHb5nRlbuR/8umrFGEfAaF8tTqDdlPgc7Epfo6sXi
 +fO90uNEZ95P3MPz5YCZJ9TQIZG6ujsEwG0Ag9e4QUjRr7aSKJ
 mRgn5A15DLGoZ3PIIFP9o0NjXqDNxs/OJxjZ/2/tXRNceaObeI
 yqRGSdjQKi1yK1q8CWocw8caHycd9x5Z1uLdxVaEbKCY8obVv/
 mtimZg/KQOmnz5jT2iyYOPQNDa00drJLATlfSCam87bHznuKbB
 Ba8Y26dKyL0FLs7e8JibbWosPnDoPV4xM+NI6uHgdQiO9dbuIh
 iOgjfonVwU13lovDiuKHb4i7ZEvAwF4vpFVY74kEWIenD1vY4v
 yzciu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 03:19:12PM +0200, Terje Bergstrom wrote:
> From: Arto Merilainen <amerilainen@nvidia.com>
>=20
> This patch removes the redundant host1x driver from tegradrm and
> makes necessary bindings to the separate host driver.
>=20
> This modification introduces a regression: Because there is no
> general framework for attaching separate devices into the
> same address space, this patch removes the ability to use IOMMU
> in tegradrm.
>=20
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>

I've been thinking about this some more and came to the conclusion that
since we will already have a tight coupling between host1x and tegra-drm
we may just as well keep the client registration code in host1x. The way
I imagine this to work would be to export a public API from tegra-drm,
say tegra_drm_init() and tegra_drm_exit(), that could be called in place
of drm_platform_init() and drm_platform_exit() in the current code.

tegra_drm_init() could then be passed the host1x platform device to bind
to. The only thing that would need to be done is move the fields in the
host1x structure specific to DRM into a separate structure. host1x would
have to export host1x_drm_init/exit() which the DRM can invoke to have
all DRM clients register to the DRM subsystem.

=46rom a hierarchical point of view this makes sense, with host1x being
the parent of all DRM subdevices. It allows us to reuse the current code
=66rom tegra-drm that has been tested and works properly even for module
unload/reload. We also get to keep the proper encapsulation and the
switch to the separate host1x driver will require a much smaller patch.

Does anybody see a disadvantage in this approach?

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvwbfAAoJEN0jrNd/PrOhAqcQALD4a0Cvs13j3n66ps530oAy
C8J7BJAGtFWsya95r0QiRB60KThVKooEzdu2H26yoNrqDiHBVXOiISuLuI51lkGY
lFk/CI2yswL5vXyR+r+HflePIo2QyHQJEu+GfntK2Y77ugCc/EZFt+1H4z+t6m3k
afsXi/IxQxjD8QYwGMUwaOreNFzp4L8kP/3LiCtv2vXSEopyzFLo+tD+VpXCxmu2
Bspql8/bF9mW2c05o5QKj1mF1Wq06LL2Zy1ZmoYPKRF4Z4ikP42h8ztBdvpHFNAK
4i55XfcwQLRdO+EFkPP+c1iMXEWX/Ee+2Q1WdOT8jE0tZURVQ+KRu50g1m081EQ2
gfrn14kdhJmAEdStWIakeekIa5x6iU0E6GPOz1FOQ28+9z/HVXX1ZNRmwFEHxG/z
ybTcJ5S99FQL1ilmMGZdgPLRZG6Q7SpwpPeGtt/a2uK8U4GoGR+SoVQ600IAn51u
2YEmbt57KhqZH7Qndhec2bpqjA9MMf5CeTOi0euybdjOjsD5oMk2is26mnKSwEQM
JfRy6VsBHQZ1HchLwZUGN6hZ3JAKRCEf9IKo0TcGaOBJxOp/ywTdry/bcN9lJl7g
3i7Lz2UauhdY6hL2U4JiSBW+iOrcLTVZI/spqgB1bqDhPA1z5LRaQhmMCcX3mWlB
tTHLTpobuWSu6WUPdTOg
=rqJ3
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
