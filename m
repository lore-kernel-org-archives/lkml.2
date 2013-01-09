Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab3AIUlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:43738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376Ab3AIUk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vlad Yasevich <vyasevich@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 089/123] sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch
Date: Wed,  9 Jan 2013 12:35:28 -0800
Message-Id: <20130109201510.038418844@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 4cb9d6eaf85ecdd266a9a5c6d825c56ca9eefc14 ]

Commit 24cb81a6a (sctp: Push struct net down into all of the
state machine functions) introduced the net structure into all
state machine functions, but jsctp_sf_eat_sack was not updated,
hence when SCTP association probing is enabled in the kernel,
any simple SCTP client/server program from userspace will panic
the kernel.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -122,7 +122,8 @@ static const struct file_operations sctp
 	.llseek = noop_llseek,
 };
 
-sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
+sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
+				     const struct sctp_endpoint *ep,
 				     const struct sctp_association *asoc,
 				     const sctp_subtype_t type,
 				     void *arg,


