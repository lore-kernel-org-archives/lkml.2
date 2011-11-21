Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1KUVsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:48:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab1KUVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:48:02 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=qdcO_AlJffIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=N0ZGmFOSvcvXGezMK5IA:9 a=DzdSofIw5ybVtgi6wDAA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=_wZGAmRqNvYqptjqRR8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111121214759.091594621@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 16:44:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 5/6] tracing: Show padding as unsigned short
References: <20111121214420.124907956@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Show-padding-as-unsigned-short.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

RT added two bytes to trace migrate disable counting to the trace events
and used two bytes of the padding to make the change. The structures and
all were updated correctly, but the display in the event formats was
not:

cat /debug/tracing/events/sched/sched_switch/format

name: sched_switch
ID: 51
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:unsigned short common_migrate_disable;	offset:8;	size:2;	signed:0;
	field:int common_padding;	offset:10;	size:2;	signed:0;

The field for common_padding has the correct size and offset, but the
use of "int" might confuse some parsers (and people that are reading
it). This needs to be changed to "unsigned short".

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1321467575.4181.36.camel@frodo
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 37d3ffb..c71844c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -117,7 +117,7 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
 	__common_field(unsigned short, migrate_disable);
-	__common_field(int, padding);
+	__common_field(unsigned short, padding);
=20
 	return ret;
 }
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOyscPAAoJEIy3vGnGbaoAGdoP/R/+bOBV5TZbkoz8ssYwSwin
rGUuhw9IyoxlQt7hHj7neRB8olC2cOa3rAIJV4q7/xXLVI+rihPNshX+hNCyPuEC
b32z6kcRM8ckJRdUAkrzA0Li2dOIDhkYeC22CGFw4jxQQBHfwYvwSCILCWztdu/e
rEG8g1P8457OL0OHPZj6uUIDB3NvfTPdFWmIlnWFnWMzfbMYd/Gcse31ey5+VHgR
mprZz3fhsIyynAQG4g0ae7+uh5LgaucSd2wPTMCrnmzJR0MM45poYbwDm5O114Pp
P49esggg9mXLYSPo4B6RfIMCcua6DqMX6TndShdgg9Yrt0y3okUIDXRWGTW2ra6s
p4OjcKBVBfki5qIdgMNhtxfpo7Ysm8W+ehA6d5yLFNaNu3FaSMQSN6iiw8nR5oYN
HFnwEZIlk1gPaLcQfKItirKdcGJk38NPfvx4FKslNeON5cP+SsPrlFutdzLMyWvb
qKZTGvEThjGnp1+W/gv9zgLOCqXwy6Lwl1yS02yRSsF20BkSRiD0wLOP03dnqyaz
xZrMo1x2ttoZY+57vDbOQaE1odHKh+OW9y6n2T5PjTod+OpId6L9mPO4dDnToJo0
AlZnygMy1EOvnA7C2Rhy88iXcQ+mLQnWFpkaOy4nbS02LdUrQ2A0Cxdl3xzB/Mm4
eUwHM3D4kgvLHL09RLmL
=fwsX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
