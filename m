Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab2J0WXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:23:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759138Ab2J0WXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:23:04 -0400
Message-ID: <1351376558.21585.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to
 use freezable_schedule()
From: Ben Hutchings <ben@decadent.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 27 Oct 2012 23:22:38 +0100
In-Reply-To: <20121026174606.GB21639@redhat.com>
References: <20121022174404.GA21553@redhat.com>
	 <20121022211317.GD5951@atj.dyndns.org> <20121023153919.GA16201@redhat.com>
	 <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com>
	 <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org>
	 <20121025173433.GA7650@redhat.com> <20121025173632.GI11442@htj.dyndns.org>
	 <20121026174545.GA21639@redhat.com> <20121026174606.GB21639@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-my9QpVPcezzFpag5fiYA"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-my9QpVPcezzFpag5fiYA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-10-26 at 19:46 +0200, Oleg Nesterov wrote:
> try_to_freeze_tasks() and cgroup_freezer rely on scheduler locks
> to ensure that a task doing STOPPED/TRACED -> RUNNING transition
> can't escape freezing. This mostly works, but ptrace_stop() does
> not necessarily call schedule(), it can change task->state back to
> RUNNING and check freezing() without any lock/barrier in between.
>=20
> We could add the necessary barrier, but this patch changes
> ptrace_stop() and do_signal_stop() to use freezable_schedule().
> This fixes the race, freezer_count() and freezer_should_skip()
> carefully avoid the race.
>=20
> And this simplifies the code, try_to_freeze_tasks/update_if_frozen
> no longer need to use task_is_stopped_or_traced() checks with the
> non trivial assumptions. We can rely on the mechanism which was
> specially designed to mark the sleeping task as "frozen enough".
>=20
> v2: As Tejun pointed out, we can also change get_signal_to_deliver()
> and move try_to_freeze() up before 'relock' label.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
[...]

This is not the correct way to submit a change to stable.  Please see
Documentation/stable_kernel_rules.txt

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-my9QpVPcezzFpag5fiYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIxer+e/yOyVhhEJAQr25w/7BDbHQLvmWQglIuyf9pfX1SD01eELzKoS
KnMA41hqPf7srh2ZvSn9NQAu7CNPfLYbX1u1QWJ/u9IYbU2EOPyVmpjx3movsJLS
AfFZOt6NoDEj6Yi3EaIE2M+W1OxbEsblD1d/yL/ocbn6lvWMxDqSSiSIvUtYBAeT
JbZukRY4IpzXFr9DGPCmrw6Xw6TGA4yaV/ubN4KzUDvIALHeXMUE9JGlRQN+Cnoz
VXwR3FMoFMKaSkTnYemREMFzk87WBrHNi6udQxnFp9J3P5Ynx8sBrXxDIwBt/2nO
+OZ9YybHg8YLQDc8v5d3xJ605EiGzD3/JmH/b6p5DSeUpSqlcO513RH3j3eHa77s
gh72OQDHj6KPcG7LByBuyZxyUhk1mHtThSb0l0C43VkvdPZD1t3WAkVq88EPb4oJ
dt7ogqj5JluU7v9oexIhAYz0OUDX/8aWDjH+0+N8rIdCSzV/4KSQsLwOxX1KuBmL
PIRq6/ybVRQNe96n5XzADORntG6oK9rrTsxCXcENvNTXdTe7ZeYYY4Sm/e07nn35
w4/rrJR/uZoxM5YAYKm/vaTr83Z4p/MpDImh7S4v06osSkit/ynkETlcbJC33qAI
I+kzupbOFFI9Mt4nV05fSQBQ7UECXi1g/UySEQ01/YPDmT5Iy4nJ5CABknf5MVEt
9ZfG8jgZCps=
=ds4D
-----END PGP SIGNATURE-----

--=-my9QpVPcezzFpag5fiYA--
