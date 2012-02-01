Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2BAVJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51251 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932453Ab2BAVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:57 -0500
X-Sasl-enc: ooHZxKmciL4Dla7p/XV7/U/tTrclOvrG3ONTypCrBKYU 1328130536
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:41 2012
Message-Id: <20120201205741.843069859@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [50/65] netns: Fail conspicously if someone uses net_generic at an inappropriate time.
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 5ee4433efe99b9f39f6eff5052a177bbcfe72cea ]

By definition net_generic should never be called when it can return
NULL.  Fail conspicously with a BUG_ON to make it clear when people mess
up that a NULL return should never happen.

Recently there was a bug in the CAIF subsystem where it was registered
with register_pernet_device instead of register_pernet_subsys.  It was
erroneously concluded that net_generic could validly return NULL and
that net_assign_generic was buggy (when it was just inefficient).
Hopefully this BUG_ON will prevent people to coming to similar erroneous
conclusions in the futrue.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netns/generic.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -41,6 +41,7 @@ static inline void *net_generic(const st
 	ptr = ng->ptr[id - 1];
 	rcu_read_unlock();
 
+	BUG_ON(!ptr);
 	return ptr;
 }
 #endif


