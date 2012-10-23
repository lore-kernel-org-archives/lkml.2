Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2JWEUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:20:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64484 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2JWEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:20:29 -0400
X-AuditID: cbfee61b-b7f616d00000319b-2c-50861b0b776c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3/4] backlight: tdo24m: add missing const
Date: Tue, 23 Oct 2012 13:20:27 +0900
Message-id: <000b01cdb0d5$bad3fcb0$307bf610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w1XpVbfPt/OpOQ+KIRjYTosJjAAAACbFg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQV1u6bYAg79NMhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujY+MG1oKNChV7Ht5kamDslepi5OSQEDCR2L3oJiuELSZx4d56
	ti5GLg4hgemMEvt3nmaGcGYzSRzrWMMEUsUmoCbx5cthdhBbRCBConnGLGYQm1mgWOJhSwtj
	FyMHUAO3xOrmIJAwpwCPxLo/nWAlwgKWEk/+zQSzWQRUJT5e2s4CYvMK2Eo8/3+MDcIWlPgx
	+R4LxEgtifU7jzNB2PISm9e8ZQYZLyGgLvHory7EBUYSK55/hbpARGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAYP5PewbiqweIQowAHoxIP
	b8f+1gAh1sSy4srcQ4wSHMxKIrzKAUAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJ
	JanZqakFqUUwWSYOTqkGxo7GBL4KQbvn/7ftWvrOovZxb0xGsWrd/4lGl5fHdnr6vOw/ILk5
	SafDLdTfa/oy4bLaJxaLnYQ+MhVL/yi/4Z7CsVQivi2zZ00m/+fApXF3Jtr/2DHr9U/OCf4l
	T3ikLT/xblm/OWO32IbZyf+y+Ga12kU8X6tbazZDgHu5x0PGrNiGs98uKbEUZyQaajEXFScC
	AHo2g1BfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'const' to static array that was missing it in its
definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/tdo24m.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 02444d0..2278a28 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -47,7 +47,7 @@ struct tdo24m {
 			((x1) << 9) | 0x100 | (x2))
 #define CMD_NULL	(-1)
 
-static uint32_t lcd_panel_reset[] = {
+static const uint32_t lcd_panel_reset[] = {
 	CMD0(0x1), /* reset */
 	CMD0(0x0), /* nop */
 	CMD0(0x0), /* nop */
@@ -55,7 +55,7 @@ static uint32_t lcd_panel_reset[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_on[] = {
+static const uint32_t lcd_panel_on[] = {
 	CMD0(0x29),		/* Display ON */
 	CMD2(0xB8, 0xFF, 0xF9),	/* Output Control */
 	CMD0(0x11),		/* Sleep out */
@@ -63,7 +63,7 @@ static uint32_t lcd_panel_on[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_off[] = {
+static const uint32_t lcd_panel_off[] = {
 	CMD0(0x28),		/* Display OFF */
 	CMD2(0xB8, 0x80, 0x02),	/* Output Control */
 	CMD0(0x10),		/* Sleep in */
@@ -71,7 +71,7 @@ static uint32_t lcd_panel_off[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_pass_through_tdo24m[] = {
+static const uint32_t lcd_vga_pass_through_tdo24m[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x80),
 	CMD1(0xE1, 0x00),
@@ -80,7 +80,7 @@ static uint32_t lcd_vga_pass_through_tdo24m[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_pass_through_tdo24m[] = {
+static const uint32_t lcd_qvga_pass_through_tdo24m[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x81),
 	CMD1(0xE1, 0x00),
@@ -89,7 +89,7 @@ static uint32_t lcd_qvga_pass_through_tdo24m[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_transfer_tdo24m[] = {
+static const uint32_t lcd_vga_transfer_tdo24m[] = {
 	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
@@ -102,7 +102,7 @@ static uint32_t lcd_vga_transfer_tdo24m[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_transfer[] = {
+static const uint32_t lcd_qvga_transfer[] = {
 	CMD1(0xd6, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd7, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd8, 0x01),	/* CKV timing control on/off */
@@ -115,7 +115,7 @@ static uint32_t lcd_qvga_transfer[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_pass_through_tdo35s[] = {
+static const uint32_t lcd_vga_pass_through_tdo35s[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x80),
 	CMD1(0xE1, 0x00),
@@ -123,7 +123,7 @@ static uint32_t lcd_vga_pass_through_tdo35s[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_qvga_pass_through_tdo35s[] = {
+static const uint32_t lcd_qvga_pass_through_tdo35s[] = {
 	CMD1(0xB0, 0x16),
 	CMD1(0xBC, 0x81),
 	CMD1(0xE1, 0x00),
@@ -131,7 +131,7 @@ static uint32_t lcd_qvga_pass_through_tdo35s[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_vga_transfer_tdo35s[] = {
+static const uint32_t lcd_vga_transfer_tdo35s[] = {
 	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
@@ -144,7 +144,7 @@ static uint32_t lcd_vga_transfer_tdo35s[] = {
 	CMD_NULL,
 };
 
-static uint32_t lcd_panel_config[] = {
+static const uint32_t lcd_panel_config[] = {
 	CMD2(0xb8, 0xff, 0xf9),	/* Output control */
 	CMD0(0x11),		/* sleep out */
 	CMD1(0xba, 0x01),	/* Display mode (1) */
@@ -175,10 +175,11 @@ static uint32_t lcd_panel_config[] = {
 	CMD_NULL,
 };
 
-static int tdo24m_writes(struct tdo24m *lcd, uint32_t *array)
+static int tdo24m_writes(struct tdo24m *lcd, const uint32_t *array)
 {
 	struct spi_transfer *x = &lcd->xfer;
-	uint32_t data, *p = array;
+	const uint32_t *p = array;
+	uint32_t data;
 	int nparams, err = 0;
 
 	for (; *p != CMD_NULL; p++) {
-- 
1.7.1


