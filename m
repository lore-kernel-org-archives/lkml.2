Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1FWRfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:35:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:34098 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1FWRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Paris <eparis@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 068/247] SELinux: define permissions for DCB netlink messages
Date: Thu, 23 Jun 2011 13:32:16 -0400
Message-Id: <1308850515-15242-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 350e4f31e0eaf56dfc3b328d24a11bdf42a41fb8 upstream.

Commit 2f90b865 added two new netlink message types to the netlink route
socket.  SELinux has hooks to define if netlink messages are allowed to
be sent or received, but it did not know about these two new message
types.  By default we allow such actions so noone likely noticed.  This
patch adds the proper definitions and thus proper permissions
enforcement.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/selinux/nlmsgtab.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index dd7cc6d..24b958c 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -66,6 +66,8 @@ static struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =
-- 
1.7.4.4

