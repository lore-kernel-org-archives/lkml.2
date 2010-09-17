Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0IQTjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 15:39:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab0IQTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 15:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QoRE9QRXoWA8iBg04A+J2CYCS2ieSTzEGlq8OUyceBpFXd55yWLRqyd5NgvcOakNhz
         +ns6NLkWsIuSBukNMabw==
MIME-Version: 1.0
In-Reply-To: <AANLkTimXnjnkNgwtEVpXKYMxXgmBdye=Gtjeggd4N9UA@mail.gmail.com>
References: <AANLkTimXnjnkNgwtEVpXKYMxXgmBdye=Gtjeggd4N9UA@mail.gmail.com>
Date: Fri, 17 Sep 2010 14:38:59 -0500
Message-ID: <AANLkTimRSjqewc_mC5vwdXy1t4Ax5rAf5svpOTbUEF7o@mail.gmail.com>
Subject: Re: [PATCH] Move "struct net" declaration inside the __KERNEL__ macro guard
From: Ollie Wild <aaw@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Marmaros <davem@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with a proper signoff.)

This patch reduces namespace pollution by moving the "struct net" declaration
out of the userspace-facing portion of linux/netlink.h.  It has no impact on
the kernel, and the declaration is not referenced anywhere outside the
__KERNEL__ macro guard.

(This came up because we have several C++ applications which use "net" as a
namespace name.)

Ollie

Signed-off-by: Ollie Wild <aaw@google.com>

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
