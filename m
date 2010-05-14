Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0ENROa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:14:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61461 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0ENRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:14:27 -0400
Date: Fri, 14 May 2010 10:12:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       Jan Engelhardt <jengelh@medozas.de>, netfilter-devel@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH -next] netfilter: xt_TEE depends on NF_CONNTRACK
Message-Id: <20100514101218.16cdb0ad.randy.dunlap@oracle.com>
In-Reply-To: <20100514161407.740da901.sfr@canb.auug.org.au>
References: <20100514161407.740da901.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BED84EA.0008:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix xt_TEE build for the case of NF_CONNTRACK=m and
NETFILTER_XT_TARGET_TEE=y:

xt_TEE.c:(.text+0x6df5c): undefined reference to `nf_conntrack_untracked'
4x

Built with all 4 m/y combinations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Patrick McHardy <kaber@trash.net>
Cc:	Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100514.orig/net/netfilter/Kconfig
+++ linux-next-20100514/net/netfilter/Kconfig
@@ -506,6 +506,7 @@ config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destiantion'
 	depends on NETFILTER_ADVANCED
 	depends on (IPV6 || IPV6=n)
+	depends on !NF_CONNTRACK || NF_CONNTRACK
 	---help---
 	This option adds a "TEE" target with which a packet can be cloned and
 	this clone be rerouted to another nexthop.
