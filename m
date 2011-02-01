Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1BAKIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:08:07 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44269 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1BAKIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:08:01 -0500
From: Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [GIT PULL nf-next-2.6 v2] IPVS build fixes and clean-ups
Date: Tue,  1 Feb 2011 21:07:43 +1100
Message-Id: <1296554868-17002-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series addresses two linux-next build problems
raised by Randy Dunlap:

* net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
* ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko]
  ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
* WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()

The remainder of the changsets are cleanups that I noticed along the way.

The changes are available at
git://git.kernel.org/pub/scm/linux/kernel/git/horms/lvs-test-2.6.git master

They are currently compile-tested only.


 include/net/ip_vs.h              |    2 --
 net/netfilter/ipvs/ip_vs_core.c  |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c   |   17 +++++++++--------
 net/netfilter/ipvs/ip_vs_lblc.c  |   20 ++++++++++----------
 net/netfilter/ipvs/ip_vs_lblcr.c |   20 ++++++++++----------
 net/netfilter/ipvs/ip_vs_sync.c  |    2 +-
 6 files changed, 31 insertions(+), 32 deletions(-)
