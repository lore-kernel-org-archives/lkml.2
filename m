Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0C3XU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:56 -0400
Received: from kroah.org ([198.145.64.141]:45970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab0C3XT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:50 2010
Message-Id: <20100330224750.347955873@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tilman Schmidt <tilman@imap.cc>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [047/156] gigaset: fix build failure
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 22001a13d09d82772e831dcdac0553994a4bac5d upstream.

Update the dummy LL interface to the LL interface change
introduced by commit daab433c03c15fd642c71c94eb51bdd3f32602c8.
This fixes the build failure occurring after that commit when
enabling ISDN_DRV_GIGASET but neither ISDN_I4L nor ISDN_CAPI.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/dummyll.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/dummyll.c
+++ b/drivers/isdn/gigaset/dummyll.c
@@ -57,12 +57,20 @@ void gigaset_isdn_stop(struct cardstate
 {
 }
 
-int gigaset_isdn_register(struct cardstate *cs, const char *isdnid)
+int gigaset_isdn_regdev(struct cardstate *cs, const char *isdnid)
 {
-	pr_info("no ISDN subsystem interface\n");
 	return 1;
 }
 
-void gigaset_isdn_unregister(struct cardstate *cs)
+void gigaset_isdn_unregdev(struct cardstate *cs)
+{
+}
+
+void gigaset_isdn_regdrv(void)
+{
+	pr_info("no ISDN subsystem interface\n");
+}
+
+void gigaset_isdn_unregdrv(void)
 {
 }


