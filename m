Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2DIRMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:12:16 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35488 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752866Ab2DIRMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:12:15 -0400
Date: Mon, 9 Apr 2012 10:12:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        airlied@linux.ie
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ
 handling broken?]
Message-ID: <20120409101210.6837aee5@jbarnes-desktop>
In-Reply-To: <alpine.LFD.2.02.1204062343050.2542@ionos>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<4F75A303.3030409@suse.cz>
	<1333110296_156038@CP5-2952>
	<4F7F60BF.9070500@suse.cz>
	<alpine.LFD.2.02.1204062343050.2542@ionos>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5mM5WJRng=MHy7mlmWSZbwY"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5mM5WJRng=MHy7mlmWSZbwY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Apr 2012 00:40:28 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:
> You know what? suspend calls free_irq() via i915_drm_freeze() ->
> drm_irq_uninstall() and the resume code calls request_irq() again.
> free_irq() removes the action and request_irq installs it fresh.

Yeah this is a known issue with the DRM code, I thought Dave had a
fix queued a long time ago though...  Dave?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/5mM5WJRng=MHy7mlmWSZbwY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgxhqAAoJEIEoDkX4Qk9hZsUQAIeUiXMNHEg//GIpsAxv0N7M
NygCc2aGxB+godwd3Ad7YmmUmwVT0F7PY2rZIVxSkwyY1ZlwxT/hiL/89xz2T9aQ
Zs0juiH+gjo9rFDfuekRakCLPNFXcGa2GNLlQ2Zi3yNFgZBhXw7DQDDylQzwyt4e
ET+rfWUpRGWkz6S4v+B7ZBF/tYU1sbYiZ7HwgQlhoOto35DyWdlInoUcy6rUhqmb
EvncP99pCGe0ZyAv3O/HfVgbIb0xHY7zVpWnII+m9m42JqHsTvqBK9GOsDNZkPhK
TVATtIHzo4lO0WkAiW2oAX+Hdqi18mJGLZBlvEy6TwaK55M8sOvv9hFYwreXxKsU
5dMj+iMbOX1CPUe0nIcfckiBz09RDv8ZnvL7f4knOfL0YdZcdPVn237EDb37UHep
6kbN3b6HXZ4H1x0mcdFQh4M1bOUE1zTwQ1AsROqRn7A3l0rap7gF1cSOhpmPhKtY
5ig98kGNe8qKKWsHDDaiVKDJnT014ar+6NDqGX1p2GbiX0ABphOgHg+nbY8xVzSI
z2HyZ7ela3iYCsCHyJA6dXmt+tVef7/Zmp04n/7alAQr9aXDipwrOFp9JhiFTQr1
aSgexAJiZFCuTCKIfB4IEHPtVPZr/A3AXiPqTqijYGK2Lv/VsBfLYkr9deyBmq4I
OUn8wt0S/B/fU3JjLFsK
=h0fK
-----END PGP SIGNATURE-----

--Sig_/5mM5WJRng=MHy7mlmWSZbwY--
