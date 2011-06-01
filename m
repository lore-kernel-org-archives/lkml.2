Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162485Ab1FAIVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:21:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:44584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162425Ab1FAIUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:20:55 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:29 2011
Message-Id: <20110601081128.817606116@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:36 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [066/165] dst: catch uninitialized metrics
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 700
Lines: 27


From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit 1f37070d3ff325827c6213e51b57f21fd5ac9d05 ]

Catch cases where dst_metric_set() and other functions are called
but _metrics is NULL.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/dst.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -120,6 +120,8 @@ static inline u32 *dst_metrics_write_ptr
 {
 	unsigned long p = dst->_metrics;
 
+	BUG_ON(!p);
+
 	if (p & DST_METRICS_READ_ONLY)
 		return dst->ops->cow_metrics(dst, p);
 	return __DST_METRICS_PTR(p);


