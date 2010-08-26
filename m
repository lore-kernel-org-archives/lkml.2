Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0HZX3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:29:38 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:38808 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0HZX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:29:36 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] intel_ips: quieten "power or thermal limit exceeded" messages
Date: Thu, 26 Aug 2010 20:29:01 -0300
Message-Id: <1282865341-17607-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <4C74686D.8090707@cesarb.net>
References: <4C74686D.8090707@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Dell Inspiron N4010, one of these messages is printed every five
seconds. Change both to dev_dbg to quieten them even more.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 drivers/platform/x86/intel_ips.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..7833adc 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -607,7 +607,7 @@ static bool mcp_exceeded(struct ips_driver *ips)
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_info(&ips->dev->dev,
+		dev_dbg(&ips->dev->dev,
 			 "MCP power or thermal limit exceeded\n");
 
 	return ret;
@@ -635,7 +635,7 @@ static bool cpu_exceeded(struct ips_driver *ips, int cpu)
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_info(&ips->dev->dev,
+		dev_dbg(&ips->dev->dev,
 			 "CPU power or thermal limit exceeded\n");
 
 	return ret;
-- 
1.7.2.2

