Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966004Ab1KJDsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965990Ab1KJDsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213206.730347563@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [241/264] netlink: validate NLA_MSECS length
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/nlattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -20,6 +20,7 @@ static const u16 nla_attr_minlen[NLA_TYP
 	[NLA_U16]	= sizeof(u16),
 	[NLA_U32]	= sizeof(u32),
 	[NLA_U64]	= sizeof(u64),
+	[NLA_MSECS]	= sizeof(u64),
 	[NLA_NESTED]	= NLA_HDRLEN,
 };
 


