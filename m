Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1HNQRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab1HNQJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.622667710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [63/90] sparc: Dont leave sparc_pmu_type NULL on sun4v.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit facfddef2c76110b8e321921f7e54518c3dd1579 ]

Otherwise we'll crash in the sparc perf init code.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/cpu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/kernel/cpu.c
+++ b/arch/sparc/kernel/cpu.c
@@ -479,6 +479,7 @@ static void __init sun4v_cpu_probe(void)
 		       prom_cpu_compatible);
 		sparc_cpu_type = "Unknown SUN4V CPU";
 		sparc_fpu_type = "Unknown SUN4V FPU";
+		sparc_pmu_type = "Unknown SUN4V PMU";
 		break;
 	}
 }


