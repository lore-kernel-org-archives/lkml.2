Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2JWETn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:19:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64364 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2JWETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:19:40 -0400
X-AuditID: cbfee61b-b7f616d00000319b-25-50861ada859e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Marek Vasut'" <marek.vasut@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 2/4] backlight: lms283gf05: add missing const
Date: Tue, 23 Oct 2012 13:19:37 +0900
Message-id: <000a01cdb0d5$9d764970$d862dc50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w1XpVbfPt/OpOQ+KIRjYTosJjAAAAAizg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd1bUm0BBhNn8llc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M1veXmArucVV8aGlgbmC8ydHFyMkhIWAi8eXHWhYIW0ziwr31
	bF2MXBxCAtMZJT7fe8IO4cxmkvi49SYbSBWbgJrEly+H2UFsEYEIieYZs5hBbGaBUoltqw8B
	2RxADdwSq5uDQMKcAjwS6/50gpUIC9hK7Hh+gQnEZhFQlTjzbREriM0LFF/V/40dwhaU+DH5
	HgvESC2J9TuPM0HY8hKb17wFGy8hoC7x6K8uxAVGEr9PLIQqEZHY9+Id4wRGoVlIJs1CMmkW
	kkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcxs+kdzCuarA4xCjAwajEw9ux
	vzVAiDWxrLgy9xCjBAezkgivcgBQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6Yklq
	dmpqQWoRTJaJg1OqgbEuxMns0DnH+KcuRz59EXgSeLqJ88GHlq/Put2Dn11eqtd2Wtj+oUpY
	hGSkVqAi0/alj4LnLOm8n+TjHm65SL03Y9e+34ze/vXSSreKrSdOvSP9svoPf+ESziXvK3of
	9rlGzv/ro3fJ+vhfiegnby53i7xUnJEUIxevoH5VWfbD5h+R0i6JLEosxRmJhlrMRcWJAKv4
	9wVfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'const' to static array that was missing it in its
definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/lms283gf05.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index ea43f22..151f0da 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -31,7 +31,7 @@ struct lms283gf05_seq {
 };
 
 /* Magic sequences supplied by manufacturer, for details refer to datasheet */
-static struct lms283gf05_seq disp_initseq[] = {
+static const struct lms283gf05_seq disp_initseq[] = {
 	/* REG, VALUE, DELAY */
 	{ 0x07, 0x0000, 0 },
 	{ 0x13, 0x0000, 10 },
@@ -78,7 +78,7 @@ static struct lms283gf05_seq disp_initseq[] = {
 	{ 0x22, 0x0000, 0 }
 };
 
-static struct lms283gf05_seq disp_pdwnseq[] = {
+static const struct lms283gf05_seq disp_pdwnseq[] = {
 	{ 0x07, 0x0016, 30 },
 
 	{ 0x07, 0x0004, 0 },
@@ -104,7 +104,7 @@ static void lms283gf05_reset(unsigned long gpio, bool inverted)
 }
 
 static void lms283gf05_toggle(struct spi_device *spi,
-			struct lms283gf05_seq *seq, int sz)
+				const struct lms283gf05_seq *seq, int sz)
 {
 	char buf[3];
 	int i;
-- 
1.7.1


