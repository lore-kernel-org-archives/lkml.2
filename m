Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0HBQM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0HBQM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:12:56 -0400
Date: Mon, 2 Aug 2010 18:09:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Woodard <bwoodard@llnl.gov>, Brian Behlendorf <behlendorf1@llnl.gov>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Mark Grondona <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial, document that div64_u64() is not precise on 32bit
	platforms
Message-ID: <20100802160951.GA13385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a bugreport which blames div64_u64() on 32bit platforms.

However, the code obviously doesn't even try to pretend it can do
the 64bit division precisely. If there is something in the high
word of divisor, div64_u64() just shifts both arguments and throws
out the low bits.

Add a small comment to avoid the confusion.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 lib/div64.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/div64.c
+++ b/lib/div64.c
@@ -77,7 +77,10 @@ s64 div_s64_rem(s64 dividend, s32 diviso
 EXPORT_SYMBOL(div_s64_rem);
 #endif
 
-/* 64bit divisor, dividend and result. dynamic precision */
+/*
+ * 64bit divisor, dividend and result. Dynamic precision, unless
+ * divisor fits in u32 result is not exactly correct.
+ */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
 {

