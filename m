Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1GIGFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:05:17 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37080 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab1GIGBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:13 -0400
X-Sasl-enc: n5Al6gd1mdgPzT8V7S65+jJqCq3UIIrzc+QNQMki3Yek 1310191272
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230112.017293958@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [25/35] netlink: Make nlmsg_find_attr take a const nlmsghdr*.
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Nelson Elhage <nelhage@ksplice.com>

commit 6b8c92ba07287578718335ce409de8e8d7217e40 upstream.

This will let us use it on a nlmsghdr stored inside a netlink_callback.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -384,7 +384,7 @@ static inline int nlmsg_parse(const stru
  *
  * Returns the first attribute which matches the specified type.
  */
-static inline struct nlattr *nlmsg_find_attr(struct nlmsghdr *nlh,
+static inline struct nlattr *nlmsg_find_attr(const struct nlmsghdr *nlh,
 					     int hdrlen, int attrtype)
 {
 	return nla_find(nlmsg_attrdata(nlh, hdrlen),


