Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2AXXUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:20:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38289 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab2AXXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:20:12 -0500
Date: Wed, 25 Jan 2012 10:20:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: linux-next: Tree for Jan 24
Message-Id: <20120125102000.df33159bdc5f627730d9b1b4@canb.auug.org.au>
In-Reply-To: <201201250018.16848.rjw@sisk.pl>
References: <20120124163055.3c99bca0d5dfd754a352fb02@canb.auug.org.au>
	<201201250018.16848.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jan_2012_10_20_00_+1100_cXhyDffoyzdfSfYc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jan_2012_10_20_00_+1100_cXhyDffoyzdfSfYc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Wed, 25 Jan 2012 00:18:16 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> Is there any new material touching kernel/workqueue.c or kernel/freezer.c?
>=20
> We seem to have a freezer regression in linux-next which doesn't seem to =
be
> present in my tree.

There are no commits in next-20120124 that touch either of those files.

Since v3.2 we have these (so in the merge window and Linus' tree):

$ git shortlog v3.2..master kernel/workqueue.c kernel/freezer.c
Tejun Heo (17):
      freezer: fix current->state restoration race in refrigerator()
      freezer: unexport refrigerator() and update try_to_freeze() slightly
      freezer: implement and use kthread_freezable_should_stop()
      freezer: rename thaw_process() to __thaw_task() and simplify the impl=
ement
      freezer: use dedicated lock instead of task_lock() + memory barrier
      freezer: make freezing indicate freeze condition in effect
      freezer: test freezable conditions while holding freezer_lock
      freezer: kill PF_FREEZING
      freezer: clean up freeze_processes() failure path
      freezer: make freezing() test freeze conditions in effect instead of =
TIF_F
      freezer: remove should_send_signal() and update frozen()
      freezer: fix set_freezable[_with_signal]() race
      freezer: restructure __refrigerator()
      freezer: use lock_task_sighand() in fake_signal_wake_up()
      freezer: remove unused @sig_only from freeze_task()
      freezer: kill unused set_freezable_with_signal()
      workqueue: make alloc_workqueue() take printf fmt and args for name

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Jan_2012_10_20_00_+1100_cXhyDffoyzdfSfYc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHzygAAoJEECxmPOUX5FEKjUQAJoUE5hOaV0MbHKACodNRwyY
ZAS3kQ4vO8lfbXz6P1iNwjsX2hPEAz1JvKMlG9Ze+5meqGCnOhRGZpFRlJlOX1lk
/gT4h72c8IG1SJnK8c5wrtF3XA5+97THykBPZolgon34eH894re9LxB/FigRLaws
0eyuulayQwA7udre+YCdUNxqcuEchACM7LQNLBnvpylCOHhJnFgTtuN/WwSqiCGO
XjczXe7qPGDoRu2q9sdI0aqGvagWGy5NwTo3FznVgbyqdJkMW1SyAPZng8g/glFo
0dAjM9HqgmnzDqe9FRMIihBVrtc/8yLs3Ruv4fNlr2KPW8cja/fd8N/1sbFzX/f3
EmM7pMJFz0kqam8vekGbVEHHIGyY9Dfx0nF5w2rqVAvBd/Nlaysa3wNVU4blgjCd
O+aAdM04fiXzcQ7zqXWlGOhYEojH1LK6TgUmiBcv8FXLrAgD00BP6VNetIuX3PPl
BoeJrjmuOR84CuIYQrnrZAnFMVfGP5hhjfE5/oatPIGAd3hgMluGStepatsQDuTI
p6w/lnu4XB9JaAcjR0El+wntgGSOxTHBAOO7JjfU49DJOQYXwQk4Mmk/NLSf1F58
lq0OiQN9A8rQ4L09gDIG+JcrY1CAhqIiE5NiZjNFcUpntgG9cYrhUkPOlv38hBKp
4Jz8PSInuOZ1XQimh1ZP
=rw8s
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jan_2012_10_20_00_+1100_cXhyDffoyzdfSfYc--
