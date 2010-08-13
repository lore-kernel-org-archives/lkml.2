Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230Ab0HMA2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:28:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761214Ab0HMA2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:28:39 -0400
Date: Fri, 13 Aug 2010 10:28:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wang Lei <wang840925@gmail.com>, David Howells <dhowells@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100813102836.c301232d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in net/Makefile
between commit 1a4240f4764ac78adbf4b0ebb49b3bd8c72ffa11 ("DNS: Separate
out CIFS DNS Resolver code") from Linus' tree and commit
28419a6b287727e879aa94f2f8662a3810d14182 ("ceph: factor out libceph from
Ceph file system") from the ceph tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/Makefile
index ea60fbc,873c2ae..0000000
--- a/net/Makefile
+++ b/net/Makefile
@@@ -67,4 -67,4 +67,5 @@@ ifeq ($(CONFIG_NET),y
  obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
  endif
  obj-$(CONFIG_WIMAX)		+= wimax/
 +obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
+ obj-$(CONFIG_CEPH_LIB)		+= ceph/
