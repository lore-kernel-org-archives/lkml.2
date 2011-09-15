Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab1IOSM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:12:28 -0400
Received: from home.keithp.com ([63.227.221.253]:56186 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934271Ab1IOSM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:12:27 -0400
From: Keith Packard <keithp@keithp.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark\, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
In-Reply-To: <4E72320B.6020000@gmx.de>
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com> <4E72320B.6020000@gmx.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 13:12:10 -0500
Message-ID: <yunwrd965fp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 17:12:43 +0000, Florian Tobias Schandinat <FlorianSchan=
dinat@gmx.de> wrote:

> Interesting that this comes from the people that pushed the latest mode s=
etting
> code into the kernel. But I don't think that this will happen, the expose=
d user
> interfaces will be around for decades and the infrastructure code could be
> shared, in theory.

We moved mode setting code from user space to kernel space -- the DRM
stuff comes directly from X, which has a fairly long history of
complicated display environments.

The DRM code does expose fb interfaces to both kernel and user mode,
figuring out how to integrate v4l2 and drm seems like the remaining
challenge.

> For fb and V4L2 I think we'll develop some level of interoperability, sha=
re
> concepts and maybe even some code. The FOURCC pixel formats and overlays =
are
> such examples. As Laurent is really interested in it I think we can get s=
ome
> nice progress here.

Jesse's design for the DRM overlay code will expose the pixel formats as
FOURCC codes so that DRM and v4l2 can interoperate -- we've got a lot of
hardware that has both video decode and 3D acceleration, so those are
going to get integrated somehow. And, we have to figure out how to share
buffers between these APIs to avoid copying data with the CPU.

DRM provides fb interfaces, so you don't need to change fb at all --
hardware that requires the capabilities provided by DRM will use that
and not use any of the other fb code in the kernel.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOcj/6Qp8BWwlsTdMRArbiAJ0SqnnRj1hbLzm8OTXYMB/815odiwCfS/yv
nf7Q5xYImP7hXamle3ducVw=
=GpFo
-----END PGP SIGNATURE-----
--=-=-=--
