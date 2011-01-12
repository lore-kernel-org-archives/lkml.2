Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1ALTsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:48:19 -0500
Received: from mail.us.es ([193.147.175.20]:38528 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab1ALTsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:48:18 -0500
Message-ID: <4D2E057D.30707@netfilter.org>
Date: Wed, 12 Jan 2011 20:48:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: XT_MATCH_REALM Kconfig whinge...
References: <20519.1294859715@localhost>
In-Reply-To: <20519.1294859715@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------040802060206090200020108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040802060206090200020108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/01/11 20:15, Valdis.Kletnieks@vt.edu wrote:
> scripts/kconfig/conf --silentoldconfig Kconfig
> warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED)
> warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED)

Does this fix your problem?

--------------040802060206090200020108
Content-Type: text/x-patch;
 name="realm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="realm.patch"

netfilter: xt_realm: fix unmet direct dependencies

scripts/kconfig/conf --silentoldconfig Kconfig
warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED)
warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED)

Reported by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1534f2b..ae56764 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -886,7 +886,8 @@ config NETFILTER_XT_MATCH_RATEEST
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
 	depends on NETFILTER_ADVANCED
-	select NET_CLS_ROUTE
+	depends on NET_SCHED
+	depends on NET_CLS_ROUTE
 	help
 	  This option adds a `realm' match, which allows you to use the realm
 	  key from the routing subsystem inside iptables.

--------------040802060206090200020108--
