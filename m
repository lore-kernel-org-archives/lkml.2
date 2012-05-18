Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946133Ab2EROMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:12:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39365 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031200Ab2EROKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:13 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 2/6] ntp: remove useless parameter
Date: Fri, 18 May 2012 16:09:54 +0200
Message-Id: <25d1b7ebb22bc559132a66209c990168f5de49ce.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some leftover cruft in the NTP code.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/ntp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index e8c8671..d4d48b0 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -540,7 +540,7 @@ static inline void notify_cmos_timer(void) { }
 /*
  * Propagate a new txc->status value into the NTP state:
  */
-static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+static inline void process_adj_status(struct timex *txc)
 {
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
 		time_state = TIME_OK;
@@ -565,10 +565,10 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
  * Called with the xtime lock held, so we can access and modify
  * all the global NTP state:
  */
-static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)
+static inline void process_adjtimex_modes(struct timex *txc)
 {
 	if (txc->modes & ADJ_STATUS)
-		process_adj_status(txc, ts);
+		process_adj_status(txc);
 
 	if (txc->modes & ADJ_NANO)
 		time_status |= STA_NANO;
@@ -673,7 +673,7 @@ int do_adjtimex(struct timex *txc)
 
 		/* If there are input parameters, then process them: */
 		if (txc->modes)
-			process_adjtimex_modes(txc, &ts);
+			process_adjtimex_modes(txc);
 
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-- 
1.7.2.5

