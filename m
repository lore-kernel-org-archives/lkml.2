Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1DKJjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:39:07 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:34822 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab1DKJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:39:05 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 05:39:04 EDT
Date: Mon, 11 Apr 2011 13:32:14 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Regression?] Removed regulator support in ehci-omap
Message-ID: <20110411093214.GA18215@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys!

Can anyone explain why regulator support has been removed from ehci-omap
driver in commit 19403165 ("usb: host: omap: ehci and ohci simplification")[1]?
In 2.6.37/2.6.38 it was enough to apply simple patch[2] adding regulators
description to board file to make USB work on omap3evm board (because USB PHY
is powered via regulator). But now it won't work anymore in 2.6.39-rc2.
BTW, I suspect that this commit also broke USB on omap3pandora board, as it
defines "hsusb0" regulator supply in its board file:

[mad@madhouse linux-2.6]$ git grep hsusb arch/arm/mach-omap2/board*
arch/arm/mach-omap2/board-omap3pandora.c:       REGULATOR_SUPPLY("hsusb0", "ehci

I can't find any clues in commit message on why regulators support was removed
and what should be used instead if this removal was intentional, so I'm a bit
puzzled about what to do now. Any help will be appreciated.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=19403165c272cc4ed00c97973e7271714b009708
[2] http://arago-project.org/git/projects/?p=linux-omap3.git;a=commitdiff;h=2ec611981ad76256d5034ae36708d807142bed1c

-- 
Best regards,
Dmitry "MAD" Artamonow

