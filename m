Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1HNQaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:30:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1HNQGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.824081335@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John David Anglin <dave.anglin@nrc-cnrc.gc.ca>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [08/90] [PARISC] fix return type of __atomic64_add_return
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John David Anglin <dave@hiauly1.hia.nrc.ca>

commit 548c210fbffdb008a80fa41ff0cb3965f185583d upstream.

The return type of __atomic64_add_return of should be s64 or long, not
int.  This fixes the atomic64 test failure that I previously reported.

Signed-off-by: John David Anglin <dave.anglin@nrc-cnrc.gc.ca>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -259,10 +259,10 @@ static __inline__ int atomic_add_unless(
 
 #define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
 
-static __inline__ int
+static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
 {
-	int ret;
+	s64 ret;
 	unsigned long flags;
 	_atomic_spin_lock_irqsave(v, flags);
 


