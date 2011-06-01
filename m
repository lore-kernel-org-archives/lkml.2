Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab1FAIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:51:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:44495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161422Ab1FAITi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:38 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:20 2011
Message-Id: <20110601081119.549569379@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:21 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick McHardy <kaber@trash.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [051/165] netfilter: nf_ct_sip: validate Content-Length in TCP SIP messages
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 813
Lines: 27


From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 274ea0e2a4cdf18110e5931b8ecbfef6353e5293 ]

Verify that the message length of a single SIP message, which is calculated
based on the Content-Length field contained in the SIP message, does not
exceed the packet boundaries.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/netfilter/nf_conntrack_sip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1461,6 +1461,8 @@ static int sip_help_tcp(struct sk_buff *
 		end += strlen("\r\n\r\n") + clen;
 
 		msglen = origlen = end - dptr;
+		if (msglen > datalen)
+			return NF_DROP;
 
 		ret = process_sip_msg(skb, ct, dataoff, &dptr, &msglen);
 		if (ret != NF_ACCEPT)


