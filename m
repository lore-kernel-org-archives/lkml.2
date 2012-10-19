Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2JSHG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:06:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2JSHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:06:26 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <dmitry.torokhov@gmail.com>, <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <dgdunix@gmail.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH 1/2] Input: matrix-keypad - remove const from pointer to array of gpios
Date: Fri, 19 Oct 2012 12:36:12 +0530
Message-ID: <1350630373-24279-2-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350630373-24279-1-git-send-email-anilkumar@ti.com>
References: <1350630373-24279-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove const from pointer to array of gpios in matrix_keypad_platform_data
struct. This is required if we update row_gpios and col_gpios based on
device tree data.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 include/linux/input/matrix_keypad.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 5f3aa6b..866124c 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -56,8 +56,8 @@ struct matrix_keymap_data {
 struct matrix_keypad_platform_data {
 	const struct matrix_keymap_data *keymap_data;
 
-	const unsigned int *row_gpios;
-	const unsigned int *col_gpios;
+	unsigned int *row_gpios;
+	unsigned int *col_gpios;
 
 	unsigned int	num_row_gpios;
 	unsigned int	num_col_gpios;
-- 
1.7.9.5

