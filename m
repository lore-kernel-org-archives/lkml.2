Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2CERLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:11:35 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:29583 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab2CERLe (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 5 Mar 2012 12:11:34 -0500
Message-Id: <4F5501D30200007800076707@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Mar 2012 17:11:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xenbus: don't free other end details too early
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part537D45D3.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part537D45D3.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The individual drivers' remove functions could legitimately attempt to
access this information (for logging messages if nothing else). Note
that I did not in fact observe a problem anywhere, but I came across
this while looking into the reasons for what turned out to need the
fix at https://lkml.org/lkml/2012/3/5/336 to vsprintf().

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xenbus/xenbus_probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.3-rc6/drivers/xen/xenbus/xenbus_probe.c
+++ 3.3-rc6-xenbus-remove-details/drivers/xen/xenbus/xenbus_probe.c
@@ -257,11 +257,12 @@ int xenbus_dev_remove(struct device *_de
 	DPRINTK("%s", dev->nodename);
=20
 	free_otherend_watch(dev);
-	free_otherend_details(dev);
=20
 	if (drv->remove)
 		drv->remove(dev);
=20
+	free_otherend_details(dev);
+
 	xenbus_switch_state(dev, XenbusStateClosed);
 	return 0;
 }




--=__Part537D45D3.3__=
Content-Type: text/plain; name="linux-3.3-rc6-xenbus-remove-details.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.3-rc6-xenbus-remove-details.patch"

The individual drivers' remove functions could legitimately attempt =
to=0Aaccess this information (for logging messages if nothing else). =
Note=0Athat I did not in fact observe a problem anywhere, but I came =
across=0Athis while looking into the reasons for what turned out to need =
the=0Afix at https://lkml.org/lkml/2012/3/5/336 to vsprintf().=0A=0ASigned-=
off-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=0A drivers/xen/xenbus/xenb=
us_probe.c |    3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=
=0A--- 3.3-rc6/drivers/xen/xenbus/xenbus_probe.c=0A+++ 3.3-rc6-xenbus-remov=
e-details/drivers/xen/xenbus/xenbus_probe.c=0A@@ -257,11 +257,12 @@ int =
xenbus_dev_remove(struct device *_de=0A 	DPRINTK("%s", dev->nodename=
);=0A =0A 	free_otherend_watch(dev);=0A-	free_otherend_details(dev);=
=0A =0A 	if (drv->remove)=0A 		drv->remove(dev);=0A =0A+	=
free_otherend_details(dev);=0A+=0A 	xenbus_switch_state(dev, XenbusStat=
eClosed);=0A 	return 0;=0A }=0A
--=__Part537D45D3.3__=--
