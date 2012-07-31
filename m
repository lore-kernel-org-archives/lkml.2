Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2GaNFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:05:46 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34028 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab2GaNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:05:44 -0400
Message-ID: <1343739939.2633.34.camel@deskari>
Subject: Re: [PATCH 15/15] workqueue: deprecate __cancel_delayed_work()
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, padovan@profusion.mobi, marcel@holtmann.org,
        peterz@infradead.org, mingo@redhat.com, davem@davemloft.net,
        dougthompson@xmission.com, ibm-acpi@hmh.eng.br, cbou@mail.ru,
        rui.zhang@intel.com, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@kernel.org>
Date: Tue, 31 Jul 2012 16:05:39 +0300
In-Reply-To: <1343433308-26614-16-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
	 <1343433308-26614-16-git-send-email-tj@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-95Y2iAoWa8AxpC+iOUg8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-95Y2iAoWa8AxpC+iOUg8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2012-07-27 at 16:55 -0700, Tejun Heo wrote:
> __cancel_delayed_work() is different from cancel_delayed_work() in
> that it uses del_timer() instead of del_timer_sync().  This adds
> confusion to already complicated flush / cancel API and given that the
> only thing delayed_work->timer does is queueing the work, the
> difference between cancel_delayed_work() and __cancel_delayed_work()
> isn't anything material.
>=20
> Furthermore, none of the remaining users are on hot path racing
> against high-frequency work item making the chance of actually waiting
> for delayed_work_timer_fn() very slim.
>=20
> Use cancel_delayed_work() instead of __cancel_delayed_work() and mark
> the latter deprecated.

I used __cancel_delayed_work() in drivers/video/omap2/dss/dsi.c as the
cancel is done in an interrupt handler. Is it safe to use
cancel_delayed_work() in atomic context? I presume not, as it uses
del_timer_sync().

 Tomi


--=-95Y2iAoWa8AxpC+iOUg8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQF9gjAAoJEPo9qoy8lh719aQP/2SfIZXPyIpfgJ1nT3pnRAKx
hox2zoQetPIJ1WP5gZNNOkqpfDB07RpV7UpYUHQeB0do+o30WHF/CVtObnZnbexQ
t+gS8PuqBDj1m7SOmOO+Phz1wdYRon6pJW1PZ8mj3ORkpWxjJefT081ypKJ7MqbU
NrWnOOTfIw0veTcUdsuzy36VdPsW41OcPEBBKgNkWDyqVZ28nOnfndZhzGWWG/I2
1EIO2WjMDwH58MmlIwTJrMg592AdI9Rqd6IGEWkiMgDospyNLvwfZW1uwlFrggSv
P+1Hb1QvUsyj91Xd9NP/r9C0/dprHLKWe0qZUzlsK18VCPBSB8M6rwNauZOKpAI8
yJ9KtVMyfakSQ0PQCuqlFE3b6gPuAlIKNVJr0vc9UmhKfbtAfe0dWFS4378nzWqL
NKAPzDKUfymwv81XIlUd0crooDlAmH+08qyNoaPemNKvU8nriebFSYFz0lgpaVjz
3FLy82keazpxFMmgTKXWbxzG+MF/7Fue6qBiYl5hTtYI9XlrEieqxaRebz/w9ySu
T7siNpxL7OazTJ3jhe5B9vnHpCLIgv0LZLmXniGHlGNiqZNGIBrwYUzTJqv6gTAW
hrrFUsVXcFxfELSQp97IdJLqDcRABDMQ1VPoWt4NR9JquCpTnb+c3TU/6UiHqEWq
TMtN7HGOV16WuUMrBIt5
=GYhW
-----END PGP SIGNATURE-----

--=-95Y2iAoWa8AxpC+iOUg8--

