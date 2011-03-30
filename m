Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab1C3Vyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:54:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:17014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366Ab1C3VHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277219"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: eparis@redhat.com, ak@linux.intel.com, jmorris@namei.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [74/275] SELinux: define permissions for DCB netlink messages
Message-Id: <20110330210511.978283E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Paris <eparis@redhat.com>

commit 350e4f31e0eaf56dfc3b328d24a11bdf42a41fb8 upstream.

Commit 2f90b865 added two new netlink message types to the netlink route
socket.  SELinux has hooks to define if netlink messages are allowed to
be sent or received, but it did not know about these two new message
types.  By default we allow such actions so noone likely noticed.  This
patch adds the proper definitions and thus proper permissions
enforcement.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/nlmsgtab.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/security/selinux/nlmsgtab.c
===================================================================
--- linux-2.6.35.y.orig/security/selinux/nlmsgtab.c	2011-03-29 22:51:40.454688035 -0700
+++ linux-2.6.35.y/security/selinux/nlmsgtab.c	2011-03-29 23:02:59.705307710 -0700
@@ -65,6 +65,8 @@
 	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =
