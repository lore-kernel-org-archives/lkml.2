Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0KCBav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:30:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0KCBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:30:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nO7dEQQVwSzjYIy/SH2AWUnYeQLCHKIPyZ226Ou6p1xwLDqGCJG+dlpu1C+booAHl
	VM4/YtkvjvKKz3rC28bSQ==
Subject: [PATCH v1 11/12] ipv4: Export arp_bind_neighbour() symbol to GPL
	modules
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:30:31 -0700
Message-ID: <20101103013030.4641.36031.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netoops driver would like to use this function to do do ARP resolution when
being configured with an IPV4 address.

Signed-off-by: Mike Waychison <mikew@google.com>
---
TODO: Is this really the right interface to get an L2 address?
---
 net/ipv4/arp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 96c1955..97b488c 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -528,6 +528,7 @@ int arp_bind_neighbour(struct dst_entry *dst)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(arp_bind_neighbour);
 
 /*
  * Check if we can use proxy ARP for this path

