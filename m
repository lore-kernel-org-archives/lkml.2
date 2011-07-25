Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1GYRzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:55:12 -0400
Received: from home.keithp.com ([63.227.221.253]:51219 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1GYRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:55:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Andrew Lutomirski <luto@mit.edu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
In-Reply-To: <CAObL_7F+xiQrsdJzaSR3nnWm-=ZiHZf8dE+Q3yv+TQC7PUYjEA@mail.gmail.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com> <20110725103732.623d7b65@jbarnes-desktop> <CAObL_7F+xiQrsdJzaSR3nnWm-=ZiHZf8dE+Q3yv+TQC7PUYjEA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 25 Jul 2011 10:55:05 -0700
Message-ID: <yun8vrmutxi.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jul 2011 13:40:58 -0400, Andrew Lutomirski <luto@mit.edu> wrote:

> Will test tonight.

Thanks.=20

> It looks like there is a lot of hotplug activity when 'xset dpms force
> off' gets run.  (That's not a typo.  I do mean "off," not "on."

Yup, that's what I've seen as well -- do a mode set to turn stuff off
and you get spammed with hotplug events.

> See attached trace.  perf rocks, even over ssh :)

Wow. You're nested about three deep in the mode setting code due to
overlapping hotplug events. What could possibly go wrong?

Makes me optimistic that a bit of locking will help a lot here.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLa35Qp8BWwlsTdMRAkn9AJ48MSbESAgGvxW/kCXt/zWQ1c1TlACcDkB0
N6M2ytU22BKxfm9kBHGeF/w=
=uVDe
-----END PGP SIGNATURE-----
--=-=-=--
