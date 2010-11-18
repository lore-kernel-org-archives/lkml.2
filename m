Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab0KRRGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:06:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab0KRRGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:06:16 -0500
Date: Thu, 18 Nov 2010 19:05:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: teach checkpatch about rcu
Message-ID: <20101118170515.GA14005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this:
+       struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
which is because checkpatch does not know about __rcu.
So here's a patch to teach it about that tag.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..1b11c8e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -143,6 +143,7 @@ our $Sparse	= qr{
 			__must_check|
 			__init_refok|
 			__kprobes|
+			__rcu|
 			__ref
 		}x;
 
-- 
1.7.3.2.91.g446ac
