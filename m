Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1JaJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:28:26 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:42784 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab1JaJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:28:25 -0400
Date: Mon, 31 Oct 2011 10:28:12 +0100
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
	(Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111031092812.GD14392@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Tejun Heo <tj@kernel.org>, Gaudenz Steinlin <gaudenz@debian.org>,
	linux-kernel@vger.kernel.org,
	Jameson Graef Rollins <jrollins@finestructure.net>,
	Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
	Martin Pitt <martin.pitt@ubuntu.com>
References: <20110904024244.GB3083@htj.dyndns.org> <87y5y37o7h.fsf@servo.factory.finestructure.net> <20110906174524.GN18425@mtj.dyndns.org> <20110907085037.GX10237@login.drsnuggles.stderr.nl> <20110911040826.GP29319@htj.dyndns.org> <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me> <20111026182650.GL14392@login.drsnuggles.stderr.nl> <20111026222510.GK24261@google.com> <20111028134743.GU14392@login.drsnuggles.stderr.nl> <20111030203503.GB7696@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOwiEbRXzl4NAN9g"
Content-Disposition: inline
In-Reply-To: <20111030203503.GB7696@google.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOwiEbRXzl4NAN9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

> The kworker submitted request but it got lost during queue destruction
> and blk_execute_rq() hangs.  There have been a number of recent
> changes in block devel tree to address this issue.  Can you please
> test the following branch?
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref
I'm running this kernel now and the problem seems to have disappeared.
I've done a dozen or so undocks and suspends, without any problems.
Also, the "udisks-daemon" process in ps now says "not polling any
devices" after undocking, where it would continue to say "polling sr0"
before.

I'll continue running this kernel for a while and inform you if the
problem resurfaces.

Any other tests I should be doing?

Thanks,

Matthijs

--GOwiEbRXzl4NAN9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk6uaiwACgkQz0nQ5oovr7x0kACgiXQ0FN+gq4NceFVOyXYWdah7
zD8Anj+ia9EkSBvAnLu4RYtXXsR2sqnH
=g70g
-----END PGP SIGNATURE-----

--GOwiEbRXzl4NAN9g--
