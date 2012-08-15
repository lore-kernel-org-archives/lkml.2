Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab2HOT4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:56:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63183 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2HOTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 123/165] netlink: validate NLA_MSECS length
Date: Wed, 15 Aug 2012 15:47:47 -0400
Message-ID: <1345060109-9187-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c30bc94758ae2a38a5eb31767c1985c0aae0950b upstream.

L2TP for example uses NLA_MSECS like this:
policy:
        [L2TP_ATTR_RECV_TIMEOUT]        = { .type = NLA_MSECS, },
code:
        if (info->attrs[L2TP_ATTR_RECV_TIMEOUT])
                cfg.reorder_timeout = nla_get_msecs(info->attrs[L2TP_ATTR_RECV_TIMEOUT]);

As nla_get_msecs() is essentially nla_get_u64() plus the
conversion to a HZ-based value, this will not properly
reject attributes from userspace that aren't long enough
and might overrun the message.

Add NLA_MSECS to the attribute minlen array to check the
size properly.

Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/nlattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index c4706eb..109d4fe 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -20,6 +20,7 @@ static u16 nla_attr_minlen[NLA_TYPE_MAX+1] __read_mostly = {
 	[NLA_U16]	= sizeof(u16),
 	[NLA_U32]	= sizeof(u32),
 	[NLA_U64]	= sizeof(u64),
+	[NLA_MSECS]	= sizeof(u64),
 	[NLA_NESTED]	= NLA_HDRLEN,
 };
 
-- 
1.7.12.rc2

