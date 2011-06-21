Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1FUBT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:19:29 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:39986 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1FUBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:19:27 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1308619166!23055583!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] svcauth_unix.c: quiet sparse noise
Date: Mon, 20 Jun 2011 18:19:12 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <Trond.Myklebust@netapp.com>, <bfields@fieldses.org>, <neilb@suse.de>,
        <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106201819.12839.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like svcauth_unix, the symbol svcauth_null is used external from this
file. Declare it as extern to quiet the following sparse noise:

warning: symbol 'svcauth_null' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index c8e1021..62e49e2 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -36,6 +36,7 @@ struct unix_domain {
 	/* other stuff later */
 };
 
+extern struct auth_ops svcauth_null;
 extern struct auth_ops svcauth_unix;
 
 static void svcauth_unix_domain_release(struct auth_domain *dom)
