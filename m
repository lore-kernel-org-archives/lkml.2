Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab0J2WN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:13:57 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39601 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757762Ab0J2WNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:13:55 -0400
Date: Sat, 30 Oct 2010 00:10:29 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        linux-wireless@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/brcm80211: simplify expression
Message-ID: <20101030001029.374336b0@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify: ((a && b) || !a) => (b || !a)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index feaffcc..aab2d8b 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -667,7 +667,7 @@ bool wlc_ps_check(wlc_info_t *wlc)
 		 * may be either true or false due to the low level override.
 		 */
 		wake = STAY_AWAKE(wlc);
-		wake_ok = (wake && ((tmp & MCTL_WAKE) != 0)) || !wake;
+		wake_ok = ((tmp & MCTL_WAKE) != 0) || !wake;
 #endif
 		if (hps && !wake_ok) {
 			WL_ERROR(("wl%d: wake not sync, sw %d maccontrol 0x%x\n", wlc->pub->unit, wake, tmp));
-- 
1.7.2.2
