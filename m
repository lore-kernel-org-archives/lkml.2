Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab1FPSgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:36:31 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:45506 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab1FPSgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:36:25 -0400
From: Eric Anholt <eric@anholt.net>
To: Ben Widawsky <ben@bwidawsk.net>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
In-Reply-To: <20110615151654.GA31881@snipes.kumite>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com> <20110615044359.GA27884@snipes.kumite> <BANLkTin1fqKMzutfOyLNegOGOuSQu-4jpA@mail.gmail.com> <20110615151654.GA31881@snipes.kumite>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 16 Jun 2011 11:36:21 -0700
Message-ID: <87wrgl8vyy.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jun 2011 08:16:54 -0700, Ben Widawsky <ben@bwidawsk.net> wrote:
> On Wed, Jun 15, 2011 at 01:04:51PM +0800, Daniel J Blueman wrote:
> > The render HWSTAM is tweaked in preinstall, but we need to tweak the
> > blitter HWSTAM (new to gen6).
> >=20
> > To me, it makes sense to reset the blitter HWSTAM register to what the
> > driver expects, in case anything before the i915 module loads and
> > adjusts it for a particular purpose (including debug); the render
> > HWSTAM is set this way too. I could add a comment to both perhaps?
>=20
> Well on that note, the docs clearly state only 1 bit can be unmasked at
> a time. Not sure if that applies to masking as well, but if it does,
> that would be not good.

This is because HWSTAM controls writes of the current ISR to the status
page, not IIR.  If you wanted to hear about more than one bit of
interrupts in that field, you'd potentially lose one of them because ISR
is "things interrupting at this very moment" not "things that have
interrupted since you last checked".  This is one of those few cases
where the hardware docs are telling you how to build software in order
to not fail, rather than telling you information about the hardware.

Given that we never look at that ISR field, then, it shouldn't matter
that we have more than one set for the render engine.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk36TSUACgkQHUdvYGzw6vc3ggCfQKPQvdx2JrEG74za8o783dqs
WEoAoJ0SxSge5WJb3DXhPDySenFM7/Xi
=V9nE
-----END PGP SIGNATURE-----
--=-=-=--
