Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1EaTAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:00:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab1EaTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:00:54 -0400
From: Colin Cross <ccross@android.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: omap2+: mux: Allow board mux settings to be NULL
Date: Tue, 31 May 2011 12:00:09 -0700
Message-Id: <1306868410-23554-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 has two mux instances, and the board may not have settings
for one of them.  Allow the board file to pass NULL for an
instance's mux settings, which will initialize the mux instance
but skip writing board settings.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-omap2/mux.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index a4ab1e3..6788dbc 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -83,6 +83,9 @@ void omap_mux_write(struct omap_mux_partition *partition, u16 val,
 void omap_mux_write_array(struct omap_mux_partition *partition,
 				 struct omap_board_mux *board_mux)
 {
+	if (!board_mux)
+		return;
+
 	while (board_mux->reg_offset != OMAP_MUX_TERMINATOR) {
 		omap_mux_write(partition, board_mux->value,
 			       board_mux->reg_offset);
-- 
1.7.4.1

