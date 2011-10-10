Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1JJNlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1JJNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:41 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=bMFhuzyJaPEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=cNoPasxiBr65vVOEx98A:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=GmHocpYND_4gnzb5el0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134140.177047478@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/20] tracing/filter: Simplify tracepoint event lookup
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-filter-Simplify-tracepoint-event-lookup.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jiri Olsa <jolsa@redhat.com>

We dont need to perform lookup through the ftrace_events list,
instead we can use the 'tp_event' field.

Each perf_event contains tracepoint event field 'tp_event', which
got initialized during the tracepoint event initialization.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-5-git-send-email-jolsa@redha=
t.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 97b93f3..0948905 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1894,17 +1894,14 @@ int ftrace_profile_set_filter(struct perf_event *ev=
ent, int event_id,
 	int err;
 	struct event_filter *filter;
 	struct filter_parse_state *ps;
-	struct ftrace_event_call *call =3D NULL;
+	struct ftrace_event_call *call;
=20
 	mutex_lock(&event_mutex);
=20
-	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->event.type =3D=3D event_id)
-			break;
-	}
+	call =3D event->tp_event;
=20
 	err =3D -EINVAL;
-	if (&call->list =3D=3D &ftrace_events)
+	if (!call)
 		goto out_unlock;
=20
 	err =3D -EEXIST;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYUAAoJEIy3vGnGbaoAgAEQAJZ4cfajTPtv6mDF6j4oeNOj
lHWi4GcU/vEufDJ+fRK/8gUXTWWWY9sV66i1qZ034xhv3wyb3aoCO2VcVpQfvNpv
NWQAsc2U1ixKm7h+et612D5fy6qu2iAb6Yn68G3uwtr+fe+HTympcZC6VSk5320v
xZaqa7zcsBK8aLW/sOisAShNi8Kskbkz/F02eeVx3LI+cRomIZy7D68gz+jidZE7
Xp6NFVyWSCK3xMa4UhES8TuoGO0PAfcXFXcnt+NOcluHejVhDYEHsn1pmge+xHra
yGNOQ7R9qf36ppBQac2O89c0DZqAR8w7f25cuYNJdPHuoHlFb1sKnvvNHCplg3KL
GFhawyb77T2Lpji8Jop5NaA+lsL8bwfrkAIwIGrj/HZqs5oTRAhUK0WPJaIuHOE9
7VmeR+gnOBXkLAEVVrhcqXJXIFB8krwVUzseZDxUvJq+yELW/08C4e1b2JSRgwNJ
azucpS9ofK+3/ADT4T68oA5LjVTp74knoQvBgjT2vNPF0vXoMmU4FhGQ9QggUzRn
/sKjYyOQ8pwl+1aCTA1EzvOJF5FxiPUyYR6gaBcOtMut4DX1NBf/q0ptOsmAq0O6
36Z1EN8LqYVzLtq+SkcXG1M5Ct8CPNSD3DHgbKW6qhMPu9pls1/31V+N6R2p6SeU
kvwmsslcJFsY+mNegnHB
=2JYt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
