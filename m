Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2KWMIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:08:50 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56728 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2KWMIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:08:49 -0500
From: James Hogan <james.hogan@imgtec.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joe Perches" <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/2] modsign: fix missing symbol prefix
Date: Fri, 23 Nov 2012 12:08:14 +0000
Message-ID: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_11_23_12_08_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix linker errors on blackfin and metag when module
signing is enabled. This is due to the use of symbol prefixes on these
architectures, and the asm in modsign_pubkey.c not prefixing one.

The first patch defines SYMBOL_PREFIX in linux/kernel based on
CONFIG_SYMBOL_PREFIX to avoid duplicated ifdef'ery all over the place.
The second patch uses SYMBOL_PREFIX to fix modsign_pubkey.c.

I'm not entirely sure linux/kernel.h is the best place for it, but there
are two other similar defines in there to avoid #ifdefs.

James Hogan (2):
  linux/kernel.h: define SYMBOL_PREFIX
  modsign: add symbol prefix to certificate list

 include/linux/kernel.h  |    7 +++++++
 kernel/modsign_pubkey.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
1.7.7.6


