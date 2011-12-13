Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1LMKkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:33 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1LMKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:30 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 02/17] UAPI: Don't include linux/compat.h in sparc's asm/siginfo.h
Date: Tue, 13 Dec 2011 10:03:58 +0000
Message-Id: <1323770653-19177-3-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't include linux/compat.h in sparc's asm/siginfo.h as it leads to a circular
dependency:

	asm/siginfo.h -> linux/compat.h -> asm/siginfo.h

Signed-off-by: David Howells <dhowells@redhat.com>
cc: David S. Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org
---
 arch/sparc/include/asm/siginfo.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/siginfo.h b/arch/sparc/include/asm/siginfo.h
index 988e5d8..215900f 100644
--- a/arch/sparc/include/asm/siginfo.h
+++ b/arch/sparc/include/asm/siginfo.h
@@ -16,8 +16,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/compat.h>
-
 #ifdef CONFIG_COMPAT
 
 struct compat_siginfo;
-- 
1.7.7.4

