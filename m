Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946648Ab2ERXRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:17:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946614Ab2ERXGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:00 -0400
Message-Id: <20120518212650.396148842@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Michael Heijenga <database.worker@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 13/47] media: dvb_frontend: fix a regression with DVB-S zig-zag
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 910a5f2e9642d5be373beae3d29e1c4a3bc7d83b upstream.

Changeset 5bfaadde broke zig-zag for DVB-S drivers that don't
implement get_tune_settings() callback.

Fix the code, in order to allow it to work as before, otherwise
some channels may not be tuned anymore.

Fix Fedora Bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=814404

Reported-by: Michael Heijenga <database.worker@googlemail.com>
Tested-by: Michael Heijenga <database.worker@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1921,6 +1921,10 @@ static int dtv_set_frontend(struct dvb_f
 	} else {
 		/* default values */
 		switch (c->delivery_system) {
+		case SYS_DVBS:
+		case SYS_DVBS2:
+		case SYS_ISDBS:
+		case SYS_TURBO:
 		case SYS_DVBC_ANNEX_A:
 		case SYS_DVBC_ANNEX_C:
 			fepriv->min_delay = HZ / 20;


