Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112Ab2JaIau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:30:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44645 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab2JaIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:30:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: platform: Don't initialize driver-private data
Date: Wed, 31 Oct 2012 09:31:27 +0100
Message-ID: <1397581.cKqVYz2Abn@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121031082607.GA1835@avionic-0098.mockup.avionic-design.de>
References: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de> <15899660.S8avMzQBpd@avalon> <20121031082607.GA1835@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1478522.qdvyXi9Zmx"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1478522.qdvyXi9Zmx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

On Wednesday 31 October 2012 09:26:07 Thierry Reding wrote:
> On Fri, Oct 26, 2012 at 04:06:27PM +0200, Laurent Pinchart wrote:
> > On Monday 15 October 2012 20:03:42 Thierry Reding wrote:
> > > Platform device drivers usually use the driver-private data for their
> > > own purposes. Having it overwritten by drm_platform_init() is confusing
> > > and error-prone.
> > 
> > If you want to push drivers that way, you should get rid of the
> > pci_set_drvdata() call in core DRM as well. This would push device driver
> > data handling down to all drivers, so I'm not convinced it would actually
> > make things simpler.
> 
> I think the problem doesn't exist for PCI-based DRM drivers, so I didn't
> look at it. The issue only arises once the DRM needs to glue together
> multiple devices, as is usual with the drivers for embedded devices,
> where the drivers are based on platform devices.
> 
> I agree, though, that for consistency it would be nicer not to do this
> for the PCI-based DRM drivers either. If David agrees I can take a look
> at converting the other drivers along with the change to the DRM core.
> 
> Pushing the handling of the driver-private data down to the drivers may
> not make things easier, but at least it would be consistent with other
> drivers. I didn't mention this in the patch description but it actually
> took me a day to track down why the driver kept crashing until I figured
> out that drm_platform_init() actually modified the pointer.

So we either need your patch, or a documentation update :-)

The patch itself is fine, I'll let others comment on the approach.

-- 
Regards,

Laurent Pinchart

--nextPart1478522.qdvyXi9Zmx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQkOHnAAoJEIkPb2GL7hl1hdAH/0Uxeyzm5szL/zv2HGu4gLdM
I/lffgB8SHAPUDUW9x4NWRQeo8+JVmlQSPscJgBt0liQybgKyGu7wOcdq0OJIdQM
PGc3w462GzSqkMBpG5eTAnbM/B4JN0VY93kCJ9gJuZODaPCNc9378/nfpQzQVzx7
1Jvfk1VysRBWE3l9ia4yM0AaIX20KEhd0adgE4FeP0cnjOFT126ttO+kY3fhPBsN
IiVwQLSdZYjW1H68P6+Hg7n6KeYq/gvNv0RH+xt0sHW18E3BKxNzs2vBnM7tKW1f
7fHQTaKb5nEJ2nkqK1d3bW0SsgeaOYD1/lTA1mY30DvtGbEH3cceMyq+LBlDEFU=
=//5v
-----END PGP SIGNATURE-----

--nextPart1478522.qdvyXi9Zmx--

