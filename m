Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab2HXCUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:20:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33005 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab2HXCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:20:05 -0400
Date: Fri, 24 Aug 2012 12:19:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120824121955.454ebce22142f238f89c9a9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_12_19_55_+1000_wFS..8v=TjKZDnH/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_12_19_55_+1000_wFS..8v=TjKZDnH/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_modes.c between commit 4eab81366465
("drm/i915: extract connector update from intel_ddc_get_modes() for
reuse") from Linus' tree and commit 451023dc32d4 ("drm: remove the
raw_edid field from struct drm_display_info") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_modes.c
index 29b7259,7a5238f..0000000
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@@ -33,25 -33,6 +33,24 @@@
  #include "i915_drv.h"
 =20
  /**
 + * intel_connector_update_modes - update connector from edid
 + * @connector: DRM connector device to use
 + * @edid: previously read EDID information
 + */
 +int intel_connector_update_modes(struct drm_connector *connector,
 +				struct edid *edid)
 +{
 +	int ret;
 +
 +	drm_mode_connector_update_edid_property(connector, edid);
 +	ret =3D drm_add_edid_modes(connector, edid);
 +	drm_edid_to_eld(connector, edid);
- 	connector->display_info.raw_edid =3D NULL;
 +	kfree(edid);
 +
 +	return ret;
 +}
 +
 +/**
   * intel_ddc_get_modes - get modelist from monitor
   * @connector: DRM connector device to use
   * @adapter: i2c adapter

--Signature=_Fri__24_Aug_2012_12_19_55_+1000_wFS..8v=TjKZDnH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNuTLAAoJEECxmPOUX5FEldsP/jL3ayJVeAjcLLJUyLVyhV2F
HMZQ2UBAoI3noklLMEmbeozVVQqAlG6sZgZxBWNWj6IKI0Z3lX8YxbI0Z3aM2sOx
c4oKO0t+C2YrKbF5E7pbVlu03KniBpGMAImDCMIhOtnWZ+mHjSFvHGtHSMvm3LEj
KADeiaPXxOQkBQw/ZwsYP7IWjDGoROsjGa+gT56dW2ds6YvrOWYs/Ol4enFsYZz7
rSdEsXhiUJqzV+A155DkZfq7+6xwfuSmj5wuS4b8wlPZ6aM53YYZvzx585DvVJ+O
hVoMjEOgUvNlfxsDHJn1hseJArHmOOsuosPGC3DgHzZdNoNJQM5Sy4/yesGw/gkE
uxkV8aArPGkxFy7+THUdlVFIMHWgMNr+d9CouL5MsHs+rNjArQYC2k3ICaqlwhIU
OfhekW+uGIKODbDs7mrHsLhut5OeI7OMDinFnzCLAAtaDkihg1zUQw69OgobffSv
aX+C9cINH5IW6mbNRHoZVPuIO1Vvv9kqfFmNvf5ea3Joz491kT8lWWU/Colo4vrO
QnnKUFv0XaUFdR+deyQHkOhjIf0/2AutbRckWBKsqJdc3Ely4Fm1JbxYYZkiSeMP
iYZlYEH0PiHNxbvtodcbOPZIwppLkgYVgv9cjgWT/0H5oICRLVpr35FQwwQLZnno
ygUiicENYbwfqaRFlYXE
=yY9T
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_12_19_55_+1000_wFS..8v=TjKZDnH/--
