Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1HLOJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:09:36 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56188 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1HLOJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:09:35 -0400
Date: Fri, 12 Aug 2011 16:08:46 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Kernel panic with intel_iommu=on
Message-ID: <20110812160846.29fd9149@laptop.anywhere.org>
In-Reply-To: <CAPM=9tzwYHgbmKUuPsrW_4nrKOQ5m+7N0JV-kMpOv43yVh-49A@mail.gmail.com>
References: <20110812145818.00cde392@laptop.anywhere.org>
	<CAPM=9tzwYHgbmKUuPsrW_4nrKOQ5m+7N0JV-kMpOv43yVh-49A@mail.gmail.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/suR/hM2E12YeNs2mIwb.WtW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/suR/hM2E12YeNs2mIwb.WtW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Aug 2011 23:51:47 +1000 Dave Airlie (DA) wrote:

DA> Does intel_iommu=3Digfx_off work as well?
DA>=20
DA> I've been seeing a few of these with Ironlake chipsets, the reason
DA> firefox does it is probably because it causes the 3D driver to be
DA> used.

With intel_iommu=3Digfx_off it works as well. Looks like that keeps IOMMU 1
disabled. So the bug seems to be in the register-based invalidation of mapp=
ings
in the DMAR engine that remaps igfx. And it must be something that firefox =
5.0
doesn't trigger, whereas 6.0 does.

For completeness, here's the relevant dmesg output with intel_iommu=3Digfx_=
off.

DMAR: Host address width 36
DMAR: DRHD base: 0x000000feb00000 flags: 0x0
IOMMU 0: reg_base_addr feb00000 ver 1:0 cap c9008020a30270 ecap 1000
DMAR: DRHD base: 0x000000feb01000 flags: 0x0
IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020230270 ecap 1000
DMAR: DRHD base: 0x000000feb03000 flags: 0x1
IOMMU 2: reg_base_addr feb03000 ver 1:0 cap c9008020230270 ecap 1000
DMAR: RMRR base: 0x000000000e0000 end: 0x000000000effff
DMAR: RMRR base: 0x0000003e600000 end: 0x0000003effffff
DMAR: No ATSR found
IOMMU 0 0xfeb00000: using Register based invalidation
IOMMU 2 0xfeb03000: using Register based invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xe0000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xe0000 - 0xeffff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O

Cheers,

	- Udo

--Sig_/suR/hM2E12YeNs2mIwb.WtW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5FM+4ACgkQnhRzXSM7nSkskQCfZdmxqHMJHlV640vB26e7q82b
6OcAnRZ9ibeS+clg8UN/AVa5LMZxZ73L
=uxoc
-----END PGP SIGNATURE-----

--Sig_/suR/hM2E12YeNs2mIwb.WtW--
