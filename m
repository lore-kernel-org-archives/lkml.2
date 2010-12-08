Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0LHBOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:14:37 -0500
Received: from kroah.org ([198.145.64.141]:33734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725Ab0LHBDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.210048747@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [238/289] DECnet: dont leak uninitialized stack byte
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 3c6f27bf33052ea6ba9d82369fb460726fb779c0 upstream.

A single uninitialized padding byte is leaked to userspace.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/decnet/af_decnet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1556,6 +1556,8 @@ static int __dn_getsockopt(struct socket
 			if (r_len > sizeof(struct linkinfo_dn))
 				r_len = sizeof(struct linkinfo_dn);
 
+			memset(&link, 0, sizeof(link));
+
 			switch(sock->state) {
 				case SS_CONNECTING:
 					link.idn_linkstate = LL_CONNECTING;


