Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362Ab2JSC7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:59:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:52284 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964953Ab2JSCtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 44/76] timekeeping: Cast raw_interval to u64 to avoid shift overflow
Date: Thu, 18 Oct 2012 19:47:08 -0700
Message-Id: <20121019024357.192231019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 5b3900cd409466c0070b234d941650685ad0c791 upstream.

We fixed a bunch of integer overflows in timekeeping code during the 3.6
cycle.  I did an audit based on that and found this potential overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1111,7 +1111,7 @@ static cycle_t logarithmic_accumulation(
 	accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
-	raw_nsecs = tk->raw_interval << shift;
+	raw_nsecs = (u64)tk->raw_interval << shift;
 	raw_nsecs += tk->raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;


