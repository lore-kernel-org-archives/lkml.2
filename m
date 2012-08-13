Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2HMWak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:30:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43711 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab2HMWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:15:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 11/65] ARM: 7476/1: vfp: only clear vfp state for current cpu in vfp_pm_suspend
Date: Mon, 13 Aug 2012 15:13:55 -0700
Message-Id: <20120813221415.958628929@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit a84b895a2348f0dbff31b71ddf954f70a6cde368 upstream.

vfp_pm_suspend runs on each cpu, only clear the hardware state
pointer for the current cpu.  Prevents a possible crash if one
cpu clears the hw state pointer when another cpu has already
checked if it is valid.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -460,7 +460,7 @@ static int vfp_pm_suspend(void)
 	}
 
 	/* clear any information we had about last context state */
-	memset(vfp_current_hw_state, 0, sizeof(vfp_current_hw_state));
+	vfp_current_hw_state[ti->cpu] = NULL;
 
 	return 0;
 }


