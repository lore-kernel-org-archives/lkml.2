Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab1BPAvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:43 -0500
Received: from kroah.org ([198.145.64.141]:46185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1BPAvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:14 2011
Message-Id: <20110216002114.188299208@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 152/176] SELinux: define permissions for DCB netlink messages
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/nlmsgtab.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -65,6 +65,8 @@ static struct nlmsg_perm nlmsg_route_per
 	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =


