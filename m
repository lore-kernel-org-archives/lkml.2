Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1AFAtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:49:13 -0500
Received: from kroah.org ([198.145.64.141]:35756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1AFAaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:01 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.148373791@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [069/152] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Nelson Elhage <nelhage@ksplice.com>

[ Upstream commit f24b8bedf70c524775eabd51570c3fa7708a97b7 ]

We need to drop the mutex and do a dev_put, so set an error code and break like
the other paths, instead of returning directly.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/econet/af_econet.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -661,8 +661,10 @@ static int ec_dev_ioctl(struct socket *s
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
+		if (!capable(CAP_NET_ADMIN)) {
+			err = -EPERM;
+			break;
+		}
 
 		edev = dev->ec_ptr;
 		if (edev == NULL) {


