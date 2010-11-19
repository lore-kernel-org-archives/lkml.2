Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab0KSA7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:59:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47254 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0KSA7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:59:19 -0500
Date: Fri, 19 Nov 2010 11:59:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bruno Randolf <br1@einfach.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the alacrity tree with the wireless
 tree
Message-Id: <20101119115914.4501da3f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

Today's linux-next merge of the alacrity tree got a conflict in
lib/Kconfig between commit c5485a7e7569ab32eea240c850198519e2a765ef
("lib: Add generic exponentially weighted moving average (EWMA)
function") from the wireless tree and commit
86613d42e6440339e9653a35d69ee5d6db361069 ("shm-signal: shared-memory
signals") from the alacrity tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.

I do need to ask if the commits in the alacrity tree are going to be
merged upstream.  The tree has not been updated since May ...
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Kconfig
index 3116aa6,af12831..0000000
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@@ -210,7 -210,25 +210,28 @@@ config GENERIC_ATOMIC6
  config LRU_CACHE
  	tristate
  
 +config AVERAGE
 +	bool
 +
+ config SHM_SIGNAL
+ 	tristate "SHM Signal - Generic shared-memory signaling mechanism"
+ 	default n
+ 	help
+ 	 Provides a shared-memory based signaling mechanism to indicate
+          memory-dirty notifications between two end-points.
+ 
+ 	 If unsure, say N
+ 
+ config IOQ
+ 	tristate "IO-Queue library - Generic shared-memory queue"
+ 	select SHM_SIGNAL
+ 	default n
+ 	help
+ 	 IOQ is a generic shared-memory-queue mechanism that happens to be
+ 	 friendly to virtualization boundaries. It can be used in a variety
+ 	 of ways, though its intended purpose is to become a low-level
+ 	 communication path for paravirtualized drivers.
+ 
+ 	 If unsure, say N
+ 
  endmenu
