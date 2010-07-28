Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0G1VnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:43:00 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:33825 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659Ab0G1Vm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:42:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Uq2iL/NHaciIRvo/wybFJ7otrq9n8CgYDa9ktFIZ8QbuxVSZwA7vCXrhPa4ogPJOzYu/qb3bajpsyZKUS26MkjbRLhgyDypdyT3+a5JmpFcUKjr0Hq6YWg7VzIvSIHLs;
Date: Wed, 28 Jul 2010 14:42:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ips driver: make it less chatty
Message-ID: <20100728144256.70666442@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a dev_warn when we exceed a thermal or power limit as
we'll handle it appropriately by clamping down on the CPU, GPU or both
as needed.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 0344822..afe82e5 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -607,7 +607,7 @@ static bool mcp_exceeded(struct ips_driver *ips)
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_warn(&ips->dev->dev,
+		dev_info(&ips->dev->dev,
 			 "MCP power or thermal limit exceeded\n");
 
 	return ret;
@@ -635,7 +635,7 @@ static bool cpu_exceeded(struct ips_driver *ips, int cpu)
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	if (ret)
-		dev_warn(&ips->dev->dev,
+		dev_info(&ips->dev->dev,
 			 "CPU power or thermal limit exceeded\n");
 
 	return ret;
