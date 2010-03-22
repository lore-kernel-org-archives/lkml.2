Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0CVEU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:20:29 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:38190 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0CVEU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:20:28 -0400
From: Eric Anholt <eric@anholt.net>
To: Karl Vogel <karl.vogel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i915 lockup / extreme delay
In-Reply-To: <ho2jal$oqs$1@dough.gmane.org>
References: <ho2jal$oqs$1@dough.gmane.org>
Date: Sun, 21 Mar 2010 21:20:24 -0700
Message-ID: <87wrx5m1h3.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
> I have been experiencing a very sluggish X server right after starting=20
> my laptop. The effect goes away after a few minutes, so it was rather=20
> hard to track down.
>=20
> Recently after updating WINE to a newer release, I've been able to=20
> trigger the effect by running a certain game under wine on a remote=20
> computer and using VirtualGL to transport the GL display to my laptop.=20
> As I first thought the issue was somewhere with wine/virtualgl, I posted=
=20
> the question to the virtualgl mailing list. The thread is here:
>=20
> http://thread.gmane.org/gmane.comp.video.opengl.virtualgl.user/170
>=20
> But after some further investigation, it seems the issue is with the=20
> i915 driver.
>=20
> The 'effect' is that only the mouse pointer works in the X server. The=20
> cpu usage on the laptop during the sluggishness is minimal. When I=20
> suspend the game with winedbg, the X server slowly becomes responsive aga=
in.
>=20
> The output from latencytop seems to point to i915 being the culprit:

If there's some code doing glFlush()es, it's probably that code at
fault.  You don't need to do that unless you're doing frontbuffer
rendering, and if you're doing frontbuffer rendering you should really
be doing backbuffer rendering.  I don't see a kernel issue here.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkum8AgACgkQHUdvYGzw6vf7/wCdEmZL7zfFR8ttwi7w4hhsG3DT
8W8An2fksvrjugbkvf8KzY9iqRnw04WX
=lUCx
-----END PGP SIGNATURE-----
--=-=-=--
