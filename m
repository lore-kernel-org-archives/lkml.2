Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2JRGiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:38:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62774 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2JRGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:38:10 -0400
Date: Thu, 18 Oct 2012 14:38:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Yong Ding <yongd@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>, Jialing Fu <jlfu@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Message-ID: <20121018063825.GC4513@S2101-09.ap.freescale.net>
References: <1348828113-19668-1-git-send-email-yongd@marvell.com>
 <1348828113-19668-2-git-send-email-yongd@marvell.com>
 <20121007140648.GA10148@S2101-09.ap.freescale.net>
 <89813612683626448B837EE5A0B6A7CB30388601C9@SC-VEXCH4.marvell.com>
 <20121018054053.GA4513@S2101-09.ap.freescale.net>
 <89813612683626448B837EE5A0B6A7CB3038855FF9@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89813612683626448B837EE5A0B6A7CB3038855FF9@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you fix your mailer to use bottom posting rather than top posting,
and have texts wrap around column 70?  Otherwise, you message stands
a good chance to be ignored by people.

On Wed, Oct 17, 2012 at 11:27:17PM -0700, Yong Ding wrote:
> Shawn,
> Thanks. Oh, sorry I really have missed the fact u mentioned. U are right in the current code, the bit will also be cleared for ESDHC_CD_GPIO. 
> But I think this is improper since for GPIO detection type, we don't use the host controller internal card detection(ESDHC_CD_CONTROLLER), but with SDHCI_QUIRK_BROKEN_CARD_DETECTION cleared, we'll still enable/disable relevant INT bits (in sdhci_set_card_detection in sdhci.c). This is my biggest concern. And I think the SDHCI_QUIRK_BROKEN_CARD_DETECTION shall be purely used to notify whether the host controller detection method is used or not. So even for the ESDHC_CD_GPIO type, we should still set this flag. How do u think?
> 
I'm fine with that.  Just remind you a fact you seem missed in case
you need to change sdhci-esdhc-imx.c to adapt the changes you are going
to make on sdhci.c.

Shawn 
