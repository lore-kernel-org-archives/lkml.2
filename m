Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1KSNi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:38:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59782 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1KSNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:38:25 -0500
Message-ID: <4EC7AFDF.6030009@gmail.com>
Date: Sat, 19 Nov 2011 14:32:15 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fixed use of rounddown_pow_of_two in ramoops
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

The return value of rounddown_pow_of_two wasn't evaluated, so the
operation was a no-op.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 drivers/char/ramoops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 7c7f42a1f8..9658116 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -126,8 +126,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
                goto fail3;
        }

-       rounddown_pow_of_two(pdata->mem_size);
-       rounddown_pow_of_two(pdata->record_size);
+       pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+       pdata->record_size = rounddown_pow_of_two(pdata->record_size);

        /* Check for the minimum memory size */
        if (pdata->mem_size < MIN_MEM_SIZE &&
