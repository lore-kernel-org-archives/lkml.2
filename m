Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1JJNlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1JJNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:45 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cwoJefEMnbMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=DNV8g0CO8eLDY5YTDmgA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=K3SIHDkUsswAnAtdgFIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134143.885174700@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:39:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/20] tracing: Add preempt disable for filter self test
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Add-preempt-disable-for-filter-self-test.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The self testing for event filters does not really need preemption
disabled as there are no races at the time of testing, but the functions
it calls uses rcu_dereference_sched() which will complain if preemption
is not disabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index 6a642e2..816d3d0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -2101,6 +2101,11 @@ static __init int ftrace_test_event_filter(void)
 			break;
 		}
=20
+		/*
+		 * The preemption disabling is not really needed for self
+		 * tests, but the rcu dereference will complain without it.
+		 */
+		preempt_disable();
 		if (*d->not_visited)
 			walk_pred_tree(filter->preds, filter->root,
 				       test_walk_pred_cb,
@@ -2108,6 +2113,7 @@ static __init int ftrace_test_event_filter(void)
=20
 		test_pred_visited =3D 0;
 		err =3D filter_match_preds(filter, &d->rec);
+		preempt_enable();
=20
 		__free_filter(filter);
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYYAAoJEIy3vGnGbaoAptwP/R8BnNpzC1JLEd3tvaY36H+G
XzbV2aDmz9jNLK72G/+hqC/h/k0P0iyH8H8XpKma7ZezR4H9Jk6WWjz4fTFQzjVL
7pGvst7qLU6l7528ILiEEVTqsoqCLguqIzrXgvWAlr0FKtJGtQTfLsMPvG7/9v4V
NDrEUvB7X4H4IyQqhEwgbRVzJC6pRZa36nw/i4T6uCXQXSO4S2tEl+wNC/YHI8si
BMQc1s0idsuloFr559yJiaO8IPknZTQVDCWmK9KtH8gTY2DAknpNQjMkWjObaswj
VKPo9bYYD609SfAD6qlhck78vWq3e7o8Z5UwPggEipnda7Afn6Bb0WhNyRYAM4UH
Wtbif6Kjl0/DnwjBKWiCqWEHKobwjkK8DIhrc6J5X/BGVXDoAG9O90mopSK15VOf
ihkQ7RamZG/y5i6/jmD/t1QMj/qNVh53zbBJaCkPpDraFhf1RGaE64ReTJxQ13ec
fxpCs2aw4qgFeEgbl1iy+y4TFB5VWeyZThoh/8ZxAUaUKOspQ9eYKghby2cX5rl2
yfGk21rMoQ5wsmWb0tAHDckMCJ6kOMNisHq0n9wG1AWDQsQqxw7YC3Mi4ZZAQAQc
+xBhL/kLm9oPHlp4WnQIF92JmtfoTXXGMDmcyZukhWQt3RnoduB/NZOBvjphPQLW
DS0CSvi1ehk7GCSfjRNP
=UwtX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
