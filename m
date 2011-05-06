Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1EFA0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:04 -0400
Received: from kroah.org ([198.145.64.141]:37330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab1EFA0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.782417797@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [127/143] ipv6: Silence privacy extensions initialization
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Romain Francoise <romain@orebokech.com>

commit 2fdc1c8093255f9da877d7b9ce3f46c2098377dc upstream.

When a network namespace is created (via CLONE_NEWNET), the loopback
interface is automatically added to the new namespace, triggering a
printk in ipv6_add_dev() if CONFIG_IPV6_PRIVACY is set.

This is problematic for applications which use CLONE_NEWNET as
part of a sandbox, like Chromium's suid sandbox or recent versions of
vsftpd. On a busy machine, it can lead to thousands of useless
"lo: Disabled Privacy Extensions" messages appearing in dmesg.

It's easy enough to check the status of privacy extensions via the
use_tempaddr sysctl, so just removing the printk seems like the most
sensible solution.

Signed-off-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/addrconf.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -407,9 +407,6 @@ static struct inet6_dev * ipv6_add_dev(s
 	    dev->type == ARPHRD_TUNNEL6 ||
 	    dev->type == ARPHRD_SIT ||
 	    dev->type == ARPHRD_NONE) {
-		printk(KERN_INFO
-		       "%s: Disabled Privacy Extensions\n",
-		       dev->name);
 		ndev->cnf.use_tempaddr = -1;
 	} else {
 		in6_dev_hold(ndev);


