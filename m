Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1IUEvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:51:38 -0400
Received: from home.keithp.com ([63.227.221.253]:39706 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1IUEvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:51:38 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 9/9] drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
In-Reply-To: <20110921094759.22423597@jbarnes-x220>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com> <1316470923-27832-10-git-send-email-keithp@keithp.com> <20110921094759.22423597@jbarnes-x220>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 20 Sep 2011 21:51:33 -0700
Message-ID: <yunsjnqfqga.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 09:47:59 +0530, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> I'm worried this makes our PPS even more complex and hard to follow.
> I'd rather see VDD AUX applied only when we need it (dpms, mode set and
> detect; for hotplug we can assume the panel is alive) and that we
> carefully disable it after waiting for a time after a full PPS on
> sequence when doing a mode set or dpms on command.

You'll see the fairly long list of places where VDD AUX is needed in my
other reply; a couple of them could probably be fixed by moving the PPS
calls around.

> Having all the power stuff at the highest levels would be clearest I
> think.

Yes, making it cleaner would help a ton. There are some basic problems
with the DRM API that make this hard though -- intel_dp_prepare may not
ever be followed by a call to intel_dp_commit. That's why I had the VDD
AUX stuff get turned off by a delayed work proc instead.

Also, leaving VDD AUX high after EDID is fetched means that we can start
the mode setting immediately, rather than having to wait for the
power-off/power-on delay (which is really long).

What we could do is force VDD AUX off after the panel gets turned on;
that would ensure that turning the panel off would actually turn the
power off, rather than having VDD stay high for some time after that.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeW1WQp8BWwlsTdMRApaaAJwKUX3Y9l0PH+WDXmz7A99jXaza7ACgvOZe
6VHL4AbzzphbiQs3X+9ypUw=
=M2kl
-----END PGP SIGNATURE-----
--=-=-=--
