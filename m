Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0LHBHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:07:42 -0500
Received: from kroah.org ([198.145.64.141]:33907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700Ab0LHBEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:08 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.061129362@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Blundell <philb@gnu.org>, "David S. Miller" <davem@davemloft.net>
Subject: [276/289] econet: fix CVE-2010-3850
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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


