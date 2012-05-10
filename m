Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2EJVWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:22:46 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:1155
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758954Ab2EJVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:22:45 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
Message-ID: <4FAC31B3.7050806@am.sony.com>
Date: Thu, 10 May 2012 14:22:59 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: android: logger: Fix some sparse and whitespace
 issues
References: <4FAC302F.2090004@am.sony.com>
In-Reply-To: <4FAC302F.2090004@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few sparse warnings, and improve whitespace.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 9ebcf42..3e8865f 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -65,9 +65,9 @@ struct logger_reader {
 };

 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
-size_t logger_offset(struct logger_log *log, size_t n)
+static size_t logger_offset(struct logger_log *log, size_t n)
 {
-	return n & (log->size-1);
+	return n & (log->size - 1);
 }


@@ -353,7 +353,7 @@ static ssize_t do_write_log_from_user(struct logger_log *log,
  * writev(), and aio_write(). Writes are our fast path, and we try to optimize
  * them above all else.
  */
-ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
+static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-- 
1.7.9.5


