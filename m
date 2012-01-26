Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2AZSd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:33:29 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44892 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab2AZSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:33:27 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] trivial: fix compiler warning
Date: Thu, 26 Jan 2012 19:32:58 +0100
Message-Id: <1327602778-25186-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327602807;217687f3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix for "‘vlan’ may be used uninitialized in
build_mlx_header()" compiler warning.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/infiniband/hw/mlx4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index aa2aefa..9e2b6df 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1363,7 +1363,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	int is_eth;
 	int is_vlan = 0;
 	int is_grh;
-	u16 vlan;
+	u16 vlan = 0;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
-- 
1.7.7.3

