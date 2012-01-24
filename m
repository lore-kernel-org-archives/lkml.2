Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2AXNve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 08:51:34 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:18707 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2AXNvd (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 24 Jan 2012 08:51:33 -0500
Message-Id: <4F1EC5BA020000780006EABF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 24 Jan 2012 13:52:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <konrad@darnok.org>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xenbus_dev: add missing error check to watch handling
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part341A68BA.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part341A68BA.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

So far only the watch path was checked to be zero terminated, while
the watch token was merely assumed to be.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xenbus/xenbus_dev_frontend.c |    4 ++++
 1 file changed, 4 insertions(+)

--- 3.3-rc1/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ 3.3-rc1-xenbus-dev-write-watch/drivers/xen/xenbus/xenbus_dev_frontend.c=

@@ -369,6 +369,10 @@ static int xenbus_write_watch(unsigned m
 		goto out;
 	}
 	token++;
+	if (memchr(token, 0, u->u.msg.len - (token - path)) =3D=3D NULL) {
+		rc =3D -EILSEQ;
+		goto out;
+	}
=20
 	if (msg_type =3D=3D XS_WATCH) {
 		watch =3D alloc_watch_adapter(path, token);




--=__Part341A68BA.4__=
Content-Type: text/plain; name="linux-3.3-rc1-xenbus-dev-write-watch.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.3-rc1-xenbus-dev-write-watch.patch"

xenbus_dev: add missing error check to watch handling=0A=0ASo far only the =
watch path was checked to be zero terminated, while=0Athe watch token was =
merely assumed to be.=0A=0ASigned-off-by: Jan Beulich <jbeulich@suse.com>=
=0A=0A---=0A drivers/xen/xenbus/xenbus_dev_frontend.c |    4 ++++=0A 1 =
file changed, 4 insertions(+)=0A=0A--- 3.3-rc1/drivers/xen/xenbus/xenbus_de=
v_frontend.c=0A+++ 3.3-rc1-xenbus-dev-write-watch/drivers/xen/xenbus/xenbus=
_dev_frontend.c=0A@@ -369,6 +369,10 @@ static int xenbus_write_watch(unsign=
ed m=0A 		goto out;=0A 	}=0A 	token++;=0A+	if =
(memchr(token, 0, u->u.msg.len - (token - path)) =3D=3D NULL) {=0A+		=
rc =3D -EILSEQ;=0A+		goto out;=0A+	}=0A =0A 	if =
(msg_type =3D=3D XS_WATCH) {=0A 		watch =3D alloc_watch_adapt=
er(path, token);=0A
--=__Part341A68BA.4__=--
