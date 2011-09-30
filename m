Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1I3RuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:50:16 -0400
Received: from home.keithp.com ([63.227.221.253]:47584 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1I3RuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:50:14 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "Cc"
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 03/21] drm/i915: Remove extra 300ms delay during eDP mode setting
In-Reply-To: <20110930162728.GC2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-4-git-send-email-keithp@keithp.com> <20110930162728.GC2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Date: Fri, 30 Sep 2011 10:50:10 -0700
Message-ID: <yun7h4p9ay5.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 18:27:28 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Can you elaborate a bit why this is no longer needed? Jesse seems to have
> introduced this spefically for edp panels in d209848d61794968. If this
> becomes rendundant due to your panel power sequencing fixes, maybe move it
> down the series?

The only reason for this delay is to avoid some potential noise on the
screen during mode setting, all of the power sequencing delays are
already correctly managed by the driver. As far as I can tell, we're
trading off the small potential for noise on the screen with an extra
300ms delay at boot time.

In the eDP spec, there's a delay listed (T8) between the start of video
data and turning on the backlight. There are no values presented and
the instructions are simply that the source is supposed to wait until
the display is stable. I'm not sure how we'd ever know that the display
is stable.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgFSQp8BWwlsTdMRApAaAKChyKoHWE5gMA6dh9smAw68lxSv8ACfU2/I
QOOqAUEfP44HLPlLchedVaQ=
=ZqzK
-----END PGP SIGNATURE-----
--=-=-=--
