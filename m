Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0C3XJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:23 -0400
Received: from kroah.org ([198.145.64.141]:48551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab0C3XJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:13 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:00 2010
Message-Id: <20100330224959.844393619@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [30/45] tc: Fix unitialized kernel memory leak
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 16ebb5e0b36ceadc8186f71d68b0c4fa4b6e781b upstream.

Three bytes of uninitialized kernel memory are currently leaked to user

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1453,6 +1453,8 @@ static int tc_fill_tclass(struct sk_buff
 	nlh = NLMSG_NEW(skb, pid, seq, event, sizeof(*tcm), flags);
 	tcm = NLMSG_DATA(nlh);
 	tcm->tcm_family = AF_UNSPEC;
+	tcm->tcm__pad1 = 0;
+	tcm->tcm__pad2 = 0;
 	tcm->tcm_ifindex = qdisc_dev(q)->ifindex;
 	tcm->tcm_parent = q->handle;
 	tcm->tcm_handle = q->handle;


