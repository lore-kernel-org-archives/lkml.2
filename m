Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0IIVSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:18:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0IIVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sXirkG2PFWglLRWYaZFL7+JzTD7H0nXmKZMccMWlZBlTewQyI6DnBXeVba9qaPlsYQ
         1phV23XBnENWER97yx/w==
MIME-Version: 1.0
Date: Thu, 9 Sep 2010 16:18:35 -0500
Message-ID: <AANLkTimXnjnkNgwtEVpXKYMxXgmBdye=Gtjeggd4N9UA@mail.gmail.com>
Subject: [PATCH] Move "struct net" declaration inside the __KERNEL__ macro guard
From: Ollie Wild <aaw@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces namespace pollution by moving the "struct net" declaration
out of the userspace-facing portion of linux/netlink.h.  It has no impact on
the kernel, and the declaration is not referenced anywhere outside the
__KERNEL__ macro guard.

(This came up because we have several C++ applications which use "net" as a
namespace name.)

Ollie

---
 include/linux/netlink.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 59d0669..1235669 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -27,8 +27,6 @@

 #define MAX_LINKS 32

-struct net;
-
 struct sockaddr_nl {
       sa_family_t     nl_family;      /* AF_NETLINK   */
       unsigned short  nl_pad;         /* zero         */
@@ -151,6 +149,8 @@ struct nlattr {
 #include <linux/capability.h>
 #include <linux/skbuff.h>

+struct net;
+
 static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
 {
       return (struct nlmsghdr *)skb->data;
--
1.7.0.4
