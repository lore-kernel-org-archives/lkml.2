Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1AORBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:01:33 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60784 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1AORB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HUrIh3UAFUG8SBG6pZZBAgTccHAwTNE6gUrlLvYk+65jDMxG6r13YoF9+qljb53zkA
         E+dcRRB01+X5kYG0r98pagv2zFMzuOJbPdBHEFP+HmqTTiCp2CXzXUo1dpJhksuUyyBL
         UM5MzSj7IYP/09Q804ybBNEIyO9OysI32L4hw=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Davide Libenzi <davidel@xmailserver.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 3/3] epoll: remove unnecessary test of ep->ovflist for available events
Date: Sat, 15 Jan 2011 11:00:37 -0600
Message-Id: <1295110837-3061-3-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110115162027.GA2552@lintop>
References: <20110115162027.GA2552@lintop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The additional test for ep->ovflist != EP_UNACTIVE_PTR to signify
available events was added in 5071f97ec6d74f006072de0ce89b67c8792fe5a1
but doesn't appear to do anything.  Either this is a bug or the check
isn't needed.

If the ep->ovflist is not EP_UNACTIVE_PTR then ep_send_events() calls
ep_scan_ready_list() which sets ep->ovflist = NULL thus loosing any
events which may have been stored there.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 57a77f5..afeb78c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1180,7 +1180,7 @@ retry:
 	}
 skip:
 	/* Is it worth to try to dig for events ? */
-	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+	eavail = !list_empty(&ep->rdllist);
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-- 
1.7.3.4

