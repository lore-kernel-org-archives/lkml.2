Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab1I1Wrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1I1Wr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220144.946434220@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Waychison <mikew@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [186/244] tcp: initialize variable ecn_ok in syncookies path
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Mike Waychison <mikew@google.com>

[ Upstream commit f0e3d0689da401f7d1981c2777a714ba295ea5ff ]

Using a gcc 4.4.3, warnings are emitted for a possibly uninitialized use
of ecn_ok.

This can happen if cookie_check_timestamp() returns due to not having
seen a timestamp.  Defaulting to ecn off seems like a reasonable thing
to do in this case, so initialized ecn_ok to false.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/syncookies.c |    2 +-
 net/ipv6/syncookies.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -276,7 +276,7 @@ struct sock *cookie_v4_check(struct sock
 	int mss;
 	struct rtable *rt;
 	__u8 rcv_wscale;
-	bool ecn_ok;
+	bool ecn_ok = false;
 
 	if (!sysctl_tcp_syncookies || !th->ack || th->rst)
 		goto out;
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -165,7 +165,7 @@ struct sock *cookie_v6_check(struct sock
 	int mss;
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
-	bool ecn_ok;
+	bool ecn_ok = false;
 
 	if (!sysctl_tcp_syncookies || !th->ack || th->rst)
 		goto out;


