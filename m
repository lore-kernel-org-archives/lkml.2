Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1LFBng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:43:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab1LFBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:20 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=UN4-jYq9wLwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=9aFY311kU8qmbhcS634A:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=lPXr9_wtrRGOnqOQFKAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014217.166071196@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 1/6] tracing: fix event_subsystem ref counting
References: <20111206014110.079874115@goodmis.org>
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
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XL5AAoJEIy3vGnGbaoA28AQAK0TDfsRQnSdkCuMOYHH6MNS
ZCBxe66ymQUUUuMERQsQAdNKb/7LJoES8g0LihwKf4T8ePLoegcDGdzhu1DCyEpv
Uq0bYo2U6PLRbI06Z7p0HxCtQejtHH4VmJJbnxhtKbdPHDoh6ysWb4psNQk7rvnB
NMVW1JlbBP98tX3X9/X8SjZTMaGuuFBdGCNdzKAk2JRe77FhI64polHTFgthb6/p
ElQEdrB75KB0w8tTjCUTo5ENJ2jESzzqFTf0TkP5xINEeFrkeJ81uKokVpaHn1np
8SjAKgqy3jgIHLw8IGeoN5MQvHcrF5XXiVoZWYGV2UzAJhDRiJCIHDOXjJ3HYBZl
Fa1zbkPVYBc1yDTOkxSnSuFDWP1x4LWTrmU17ROFRL+qec9eif9g2sEnPTeVA8Q3
Bz66b9yyD4JQ9Y9sq7dVSL7+SUiisqyymoYqlo+srhUUwBE5mnjbs7pBcK4YXZTb
yXxtAPHAv1nE0tvnlSa5lm7lDjMiwNpswG28PDOEvPCBm57gi70jm4NP6k9PdtM+
00Qd4kT4ttlQ0vm4MnrJ0YKk6/aU1DbCqjB1kc6Rw83LcL7lxmd4gXrRFCEHX2bc
S9ON0CGVpMRt0J/Pa3mRz6FOJpvGrtZ4uGHuE3SOEVz2xMe5ZtE/Acf/P1CKxCvZ
2QETZVhmsI3eA8b9BSHA
=AxEg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
