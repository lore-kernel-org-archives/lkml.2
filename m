Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1D1IGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:06:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46167 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1D1IGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nVJUCn9NhqGRqRfjEs99LjoCvhMqfJR3f86/Qj751e4w7TvlfV8H2OFAemgPDjTtx1
         bVkFtwlt37xtPAYS5clfwDh0pzhyBtE/UkgufYg4soVABBw3AtDFAtMXPjHJmKuIFCjA
         j5OhJ2NN3iwNQ6SPmlzQziVQhChD9JnehCfv8=
From: Lifeng Sun <lifongsun@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lifeng Sun <lifongsun@gmail.com>
Subject: [PATCH 1/5] networking: inappropriate ioctl operation should return ENOTTY
Date: Thu, 28 Apr 2011 16:04:51 +0800
Message-Id: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <20110427130904.47331a9f@lxorguk.ukuu.org.uk>
References: <20110427130904.47331a9f@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl() calls against a socket with an inappropriate ioctl operation
are incorrectly returning EINVAL rather than ENOTTY:

  [ENOTTY]
      Inappropriate I/O control operation.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=33992

Signed-off-by: Lifeng Sun <lifongsun@gmail.com>
---
 net/core/dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c2ac599..856b6ee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4773,7 +4773,7 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 		 * is never reached
 		 */
 		WARN_ON(1);
-		err = -EINVAL;
+		err = -ENOTTY;
 		break;
 
 	}
@@ -5041,7 +5041,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		/* Set the per device memory buffer space.
 		 * Not applicable in our case */
 	case SIOCSIFLINK:
-		return -EINVAL;
+		return -ENOTTY;
 
 	/*
 	 *	Unknown or private ioctl.
@@ -5062,7 +5062,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		/* Take care of Wireless Extensions */
 		if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
 			return wext_handle_ioctl(net, &ifr, cmd, arg);
-		return -EINVAL;
+		return -ENOTTY;
 	}
 }
 
-- 
1.7.5.rc1

