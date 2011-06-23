Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab1FWRnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:43:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:35638 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933845Ab1FWRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 235/247] netlink: Make nlmsg_find_attr take a const nlmsghdr*.
Date: Thu, 23 Jun 2011 13:35:03 -0400
Message-Id: <1308850515-15242-176-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6b8c92ba07287578718335ce409de8e8d7217e40 upstream.

This will let us use it on a nlmsghdr stored inside a netlink_callback.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/netlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4fc05b5..28c27d1 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -384,7 +384,7 @@ static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
  *
  * Returns the first attribute which matches the specified type.
  */
-static inline struct nlattr *nlmsg_find_attr(struct nlmsghdr *nlh,
+static inline struct nlattr *nlmsg_find_attr(const struct nlmsghdr *nlh,
 					     int hdrlen, int attrtype)
 {
 	return nla_find(nlmsg_attrdata(nlh, hdrlen),
-- 
1.7.4.4

