Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0HWGT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:19:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:36196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0HWGTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:19:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,255,1280732400"; 
   d="asc'?scan'208";a="599184350"
Date: Mon, 23 Aug 2010 14:19:22 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Fix dma mask for Sandybridge
Message-ID: <20100823061922.GD29442@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <s5hlj81cn4n.wl%tiwai@suse.de>
 <20100823013507.GA29442@zhen-devel.sh.intel.com>
 <s5h62z1ew1y.wl%tiwai@suse.de>
 <20100823054303.GC29442@zhen-devel.sh.intel.com>
 <s5hzkwddfy5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Content-Disposition: inline
In-Reply-To: <s5hzkwddfy5.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.08.23 08:02:42 +0200, Takashi Iwai wrote:
>=20
> Also, I don't understand the logic of 40bit addr calculation:
>=20
> > static unsigned long intel_gen6_mask_memory(struct agp_bridge_data *bri=
dge,
> >                                             dma_addr_t addr, int type)
> > {
> >         /* Shift high bits down */
> >        addr |=3D (addr >> 28) & 0xff;
>=20
> Isn't it 0xff0?
>=20

No. This depends on hw 32bit PTE format for sandybridge.

bit 31			 bit 11			 bit 4			bit 0
   |<-physical addr 31:12->|<-physical addr 39:32->|<-cache ctl 3:1->|valid|

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxyEuoACgkQsQQaM014GCf1YwCgj5rUQFUV8MlM1vV6owKVHoOt
hQIAnieiUgTUv6SsPgjNNfyoTKCL/V8G
=bsQQ
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--
