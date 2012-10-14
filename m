Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2JNPRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:17:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824Ab2JNOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:37 -0400
Message-Id: <20121014143536.203065496@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 018/147] tools/hv: Fix exit() error code
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6bb22fea25624ab593eee376fa5fb82d1b13f45a upstream.

Linux native exit codes are 8-bit unsigned values.  exit(-1) results
in an exit code of 255, which is usually reserved for shells reporting
'command not found'.  Use the portable value EXIT_FAILURE.  (Not that
this matters much for a daemon.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: drop changes to exit() calls not in this version]
---
 tools/hv/hv_kvp_daemon.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -348,7 +348,7 @@ int main(void)
 	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 	if (fd < 0) {
 		syslog(LOG_ERR, "netlink socket creation failed; error:%d", fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	addr.nl_family = AF_NETLINK;
 	addr.nl_pad = 0;
@@ -360,7 +360,7 @@ int main(void)
 	if (error < 0) {
 		syslog(LOG_ERR, "bind failed; error:%d", error);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	sock_opt = addr.nl_groups;
 	setsockopt(fd, 270, 1, &sock_opt, sizeof(sock_opt));
@@ -378,7 +378,7 @@ int main(void)
 	if (len < 0) {
 		syslog(LOG_ERR, "netlink_send failed; error:%d", len);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	pfd.fd = fd;
@@ -497,7 +497,7 @@ int main(void)
 		len = netlink_send(fd, incoming_cn_msg);
 		if (len < 0) {
 			syslog(LOG_ERR, "net_link send failed; error:%d", len);
-			exit(-1);
+			exit(EXIT_FAILURE);
 		}
 	}
 


