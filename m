Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1HFAHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1HFAHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:50 2011
Message-Id: <20110806000250.077216821@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Manjunath Hadli <manjunath.hadli@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [12/55] davinci: DM365 EVM: fix video input mux bits
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Povey <jon.povey@racelogic.co.uk>

commit 9daedd833a38edd90cf7baa1b1fcf61c3a0721e3 upstream.

Video input mux settings for tvp7002 and imager inputs were swapped.
Comment was correct.

Tested on EVM with tvp7002 input.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Acked-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-davinci/board-dm365-evm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -413,7 +413,7 @@ fail:
 	 */
 	if (have_imager()) {
 		label = "HD imager";
-		mux |= 1;
+		mux |= 2;
 
 		/* externally mux MMC1/ENET/AIC33 to imager */
 		mux |= BIT(6) | BIT(5) | BIT(3);
@@ -434,7 +434,7 @@ fail:
 		resets &= ~BIT(1);
 
 		if (have_tvp7002()) {
-			mux |= 2;
+			mux |= 1;
 			resets &= ~BIT(2);
 			label = "tvp7002 HD";
 		} else {


