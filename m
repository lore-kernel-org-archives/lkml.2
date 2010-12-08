Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0LHAfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:35:18 -0500
Received: from kroah.org ([198.145.64.141]:54939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0LHAe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:59 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:44 2010
Message-Id: <20101208000644.035058701@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Blundell <philb@gnu.org>, "David S. Miller" <davem@davemloft.net>
Subject: [44/44] econet: fix CVE-2010-3850
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Blundell <philb@gnu.org>

commit 16c41745c7b92a243d0874f534c1655196c64b74 upstream.

Add missing check for capable(CAP_NET_ADMIN) in SIOCSIFADDR operation.

Signed-off-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/econet/af_econet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -661,6 +661,9 @@ static int ec_dev_ioctl(struct socket *s
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
 			/* Magic up a new one. */


