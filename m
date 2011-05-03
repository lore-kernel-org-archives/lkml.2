Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1ECOvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:51:42 -0400
Received: from home.keithp.com ([63.227.221.253]:51774 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab1ECOsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:48:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-bluetooth@vger.kernel.org,
        Vinicius Gomes <vinicius.gomes@openbossa.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <20110503092734.1c153fc3@susi.home.s3e.de>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper> <20110411173409.1567679c@lxorguk.ukuu.org.uk> <BANLkTinK-cA67X6Knp-h5SKpjpDpwaMgZg@mail.gmail.com> <yunaafjs28n.fsf@aiko.keithp.com> <20110421225953.GA2323@joana> <yun62q7i21o.fsf@aiko.keithp.com> <20110423163759.GB2323@joana> <20110503092734.1c153fc3@susi.home.s3e.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 03 May 2011 07:48:03 -0700
Message-ID: <yunvcxr6dss.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 3 May 2011 09:27:34 +0200, Stefan Seyfried <stefan.seyfried@googlem=
ail.com> wrote:

> Did this hit mainline already? I seem to suffer from this still with
> -rc5

It's on master, but not in -rc5:

commit b79f44c16a4e2181b1d6423afe746745d5e949ff
Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Date:   Mon Apr 11 18:46:55 2011 -0300

    Bluetooth: Fix keeping the command timer running
=20=20=20=20
    In the teardown path the reset command is sent to the controller,
    this event causes the command timer to be reactivated.
=20=20=20=20
    So the timer is removed in two situations, when the adapter isn't
    marked as UP and when we know that some command has been sent.
=20=20=20=20
    Reported-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>

I'll be testing this patch shortly.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNwBWjQp8BWwlsTdMRAjBWAJ4lQUatD52yW7g0jYCpgbhs5UqrIACg1kzV
f/aMjcKAcIzmgKvjRTHOuCA=
=C2Yn
-----END PGP SIGNATURE-----
--=-=-=--
