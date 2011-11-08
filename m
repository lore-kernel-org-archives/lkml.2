Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1KHBcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:32:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1KHBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:38 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=vqU-PY24e2MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=9aFY311kU8qmbhcS634A:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=q1Bnt8I_OFarh4mrsIUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013036.621852474@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 01/10] tracing: fix event_subsystem ref counting
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-fix-event_subsystem-ref-counting.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Ilya Dryomov <idryomov@gmail.com>

Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
ever being released.

Ref_count was added to keep track of subsystem users, not for counting
events.  Subsystem is created with ref_count =3D 1, so there is no need to
increment it for every event, we have nr_events for that.  Fix this by
touching ref_count only when we actually have a new user -
subsystem_open().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Link: http://lkml.kernel.org/r/1320052062-7846-1-git-send-email-idryomov@gm=
ail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..c212a7f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1078,7 +1078,6 @@ event_subsystem_dir(const char *name, struct dentry *=
d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) =3D=3D 0) {
-			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY8AAoJEIy3vGnGbaoAlIQQALlTRWDbF5Q7LJRlmnyTW+t8
sWu9/R6o+Ep87TVbhkEwsDEjDWSyyNSjrCKYMmC2BCee13xDy/jIkeEndefVw7f2
UTqlVks9tN9/+atQrBDBxGvzdvz2PFjPFlEwwAh/s0yGzLwfZwpb9OOWdrDUC3T3
oaCHlKi0PHKu0v/8UuzfNiqDitiS3QXUgBtLYArhbkVIzvLlchfPxo+9l/etN0ZP
n1A3X88o7cVFWoX+3djaAZMvb6adJDrwAJPJNuz/0x7jmVUXQVFCqHq27l8iManO
jJB+m4zXiWjRdyTqYqq6i89t8ZOk3N38NLzxyqINZEs0Q4J4oyIlMqsszCAUl0VL
NXzDZOIzQVAfdJzP9O7ICA3MhdLDynsegIf8CxDj+v46nrJr9qozThtxXuHa+qZl
pOLtvHygc751xo2jx9yGmYeBNjK+jjrEu1/O/IcjwB64Lbi9ynedzabWOGsX5xGF
LviZ0bdYeM9cJGEyJsqncaAbWcGkH+0Wt8OJ3QLZQYyQIOfZT8xZN8xuCzXFCOwA
Xs7vrXQ+a7k9KzLcfcW9aPiBrbFLQuThivzuAA+Ad6tj0Tll5WoBYvnpuvFSgeEW
Xn68akD4pbBhBpZjHvd2N2SWGgYRZdIHVGRrn0phWmzJiaCDNiveh+ogFqqeHpZz
JgRFrJA78e6zPH+OzkBl
=ZTmQ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
