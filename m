Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2HQXKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:10:50 -0400
Received: from home.keithp.com ([63.227.221.253]:52321 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab2HQXKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:10:42 -0400
From: Keith Packard <keithp@keithp.com>
To: "Lespiau\, Damien" <damien.lespiau@intel.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/7] drm/i915: Disable FDI RX before FDI TX
In-Reply-To: <CAPX-8+_bZNyXL0b8nBkN97sj-KnT_eZXZ-5Hp5R6P-L-D-QAKg@mail.gmail.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com> <1344918891-6283-7-git-send-email-keithp@keithp.com> <CAPX-8+_bZNyXL0b8nBkN97sj-KnT_eZXZ-5Hp5R6P-L-D-QAKg@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Fri, 17 Aug 2012 16:10:57 -0700
Message-ID: <86393lunb2.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

"Lespiau, Damien" <damien.lespiau@intel.com> writes:

> I can't see anything in the docs about an order requirement for those.

Right, the docs don't say anything, which is a bit disconcerting.

> Not sure why the other way does not make sense. Somehow disabling TX
> before RX makes some sense to me (TX enabled without a ready RX looks
> weird?, no data should flow as the pipe is shutdown at that point
> anyway). Maybe it just does not matter?

And here I figured disabling RX before TX made more sense -- otherwise
the receiver wouldn't be seeing anything. In other areas of the driver,
we're careful to disable receivers before senders (disable CRTC before
PLL, etc).

> Another detail is that disabling the PLLs seem to have an order in the
> disabling sequence, TX, then RX.
>
> I.  Disable CPU FDI Transmitter PLL
> II. Disable PCH FDI Receiver PLL

That ordering doesn't matter as the FDI receiver and transmitter are
both disabled by that point, so they aren't talking at all.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUC7PgjYtFsjWk68qAQgAkg//ROGG75eVoPQR/7gw4Vo+m5IQEyriAXOi
bkYY++p4UPv/3ky4Roww/yxEE7wORTi0/C8ORAeYy+UPmHvWc84he2xdO2hZmbu2
9tF5bVkuem5SY7iJXR8df2Il/7jZ5ygAwykbOeA6wCBzyX7egNJvDMhszD9xdakI
JprPoUS6QUPdwL+2irN9mi+ftLfJDmauK2IBSdwvi2UXQuZnHGR93Smrmzuv00QJ
LMWYZR52+g34q9GcyiQQ1Jhl59NvVzBfNTsKMeViskhIDU0Q7Nxa6sPeAy2fgpad
968g4x2RQd0J93IVfYsUKnJT3txBrbjjucJ1GvokvV24USlbL2O51ZnUkIjypawy
k5E3yR2qQBey7PL4zRJAmbt4Rs63XJkH6yd44pQyCAgtUnKke/bw5aenSwqY8b+M
8VQry5bKi4Vqmh89c2MtqdZwSUT5oAiDAzjQJ7F4k3D2Fo0NPMaaN+Cdecz6MADo
AqWF+bmx8tU1SCT9syEIEotM+NTnU3xyzHXa0geqW0d+h0efmnDzwpNnFa4AhScB
s6aoovzNWW0U1JE2iHTTKfeT2gMvzupCA+z++geoE1s90HWQNfIHLlIbJtppmQ3O
SxqvfPx69NjK1xRSGrcfInUFLsoQ8nNXdJa55QKDvt9W7HboCq0n9NV/ld/HCjpz
EqaraMKpze8=
=26Nr
-----END PGP SIGNATURE-----
--=-=-=--
