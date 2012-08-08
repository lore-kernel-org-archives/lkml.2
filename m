Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2HHOrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:47:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab2HHOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Paul Parsons <lost.distance@yahoo.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 02/11] mfd/asic3: fix asic3_mfd_probe return value
Date: Wed,  8 Aug 2012 16:47:19 +0200
Message-Id: <1344437248-20560-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BQTU6HmlEB1Dwy+y5HiETfO3iNX7jVzrTGmq0MiEmQ7
 1TTjncTNUAeZvBXoQRDh7F8HORGX6MIoQQNeTTi06V+5yVVfK4
 yfAn0tWceZQfOA/tG9MrS7gE4WAXqHCotIx6gJJP0K3H0VeBfb
 pj+fSqaJRQhNZDonse4TTzIQIsmQhw4xb0jv/sTv7H0i0dwGvB
 XZUfz/cM15EtRYetDa9mPqKqL/uhBlhT/IIWiBscLNOBi/7ozd
 2jI3u2P/qP4nGxbAVhOmHnhimnq21Dc5Z64p6lXQJbrgcloPNk
 wwRzyqh6uTWXHC+bAzzddqhtWEbKgNvymWI7ZpM9Z+jHZP0AJh
 +KomE6mJ3wiLKxJeColMpFR6OOT6psetGSKAgpPrue1k0HG9jx
 MJmZDBmzjztgC6JOFJITBc/z3/Bn1f5QhY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4f304245b "mfd: Set asic3 DS1WM clock_rate", a possible
path through asic3_mfd_probe was introduced that would lead to
an unpredictable return value, if everything succeeds but there
are pdata->leds is NULL. This was reported correctly by gcc.

Without this patch, building magician_defconfig results in:

drivers/mfd/asic3.c: In function 'asic3_mfd_probe':
drivers/mfd/asic3.c:940:2: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/asic3.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 383421b..683e18a 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -925,6 +925,7 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 			goto out;
 	}
 
+	ret = 0;
 	if (pdata->leds) {
 		int i;
 
-- 
1.7.10

