Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1LUSyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:54:49 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56109 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1LUSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:54:46 -0500
Date: Wed, 21 Dec 2011 19:54:10 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: intel-gfx@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: GPU hung with Linux-3.2-rc6
Message-ID: <20111221195410.5e4c065a@x220.fritz.box>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=DvYb=bFa+Xjwb1H/S5kFtg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=DvYb=bFa+Xjwb1H/S5kFtg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

With Linux-3.2-rc6 I'm frequently seeing GPU hangs when large amounts of
text scroll in an xterm, such as when extracting a tar archive. Such as this
one (note the timestamps):

[22865.157750] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed=
... GPU hung
[22865.157763] [drm:kick_ring] *ERROR* Kicking stuck semaphore on render ri=
ng
[22871.165992] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed=
... GPU hung
[22871.166008] [drm:kick_ring] *ERROR* Kicking stuck semaphore on render ri=
ng
[22877.417902] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed=
... GPU hung
[22877.417915] [drm:kick_ring] *ERROR* Kicking stuck semaphore on render ri=
ng
[22883.426132] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed=
... GPU hung
[22883.426146] [drm:kick_ring] *ERROR* Kicking stuck semaphore on render ri=
ng

These hangs did not occur with Linux 3.1 or they were so infrequent that I
didn't notice them. The machine is an x220 laptop with SNB CPU. The kernel
command line contains:

i915.i915_enable_rc6=3D1 i915.i915_enable_fbc=3D1 i915.lvds_downclock=3D1

Note that VT-d is enabled in the BIOS, but the kernel is compiled without
IOMMU support. Because the IOMMU is not enabled, I'm inclined to think that
this problem is not VT-d related.

Cheers,

	- Udo

--Sig_/=DvYb=bFa+Xjwb1H/S5kFtg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7yK1MACgkQnhRzXSM7nSmqTQCcDAuSgUe/HJwbdwxoZvJ+dPuy
yf0An2xY3gA8pZBM+WCGwFxQZJMPqzV7
=Hyj2
-----END PGP SIGNATURE-----

--Sig_/=DvYb=bFa+Xjwb1H/S5kFtg--
