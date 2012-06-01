Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab2FAOsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:48:18 -0400
Received: from void.printf.net ([89.145.121.20]:34824 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933337Ab2FAOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:48:17 -0400
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Torne \(Richard Coles\)" <torne@google.com>,
        Ben Hutchings <ben@decadent.org.uk>, linus.walleij@linaro.org,
        jh80.chung@samsung.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
In-Reply-To: <4FC8BCA0.1000207@intel.com> (Adrian Hunter's message of "Fri, 01
	Jun 2012 15:59:12 +0300")
References: <1338226278-13336-1-git-send-email-torne@google.com>
	<1338258732.20487.171.camel@deadeye> <4FC87EEA.5010707@intel.com>
	<CAEV-rjcFx_+Zs+1K5rxapx7ngDkArEKSV8tDubbVL+BfYLDU5Q@mail.gmail.com>
	<CAEV-rjfkcoEc-4VmMS-wQburo5tZZVDemzHk8LyKGhuLfFnSng@mail.gmail.com>
	<4FC894E6.7090000@intel.com>
	<CAEV-rjc0i5i3nU+VgkY3-mF_ndtSzzp8vk7622C9WCNsfcRP+A@mail.gmail.com>
	<4FC8BCA0.1000207@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 01 Jun 2012 10:48:14 -0400
Message-ID: <87pq9jhyvl.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 01 2012, Adrian Hunter wrote:
> I just noticed that from linux 3.4, the SD write timeout is now 3 seconds
> triggering the sdhci driver warning on every write on every SD card.
> So change pr_warning to DGB in sdhci_calc_timeout().  Chris?

Oops, thanks for noticing:


Subject: mmc: sdhci: Use DBG() instead of pr_warning() on large timeout

3bdc9ba892d6 ("mmc: use really long write timeout to deal with crappy
cards") in 3.4 increased the write timeout that the core sends to host
drivers to 3 seconds.  This makes sdhci's "requested timeout too large"
warning trigger on every write; so, change this pr_warning() to a DBG().

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/sdhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index e626732..f4b8b4d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -680,8 +680,8 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (count >= 0xF) {
-		pr_warning("%s: Too large timeout 0x%x requested for CMD%d!\n",
-			   mmc_hostname(host->mmc), count, cmd->opcode);
+		DBG("%s: Too large timeout 0x%x requested for CMD%d!\n",
+		    mmc_hostname(host->mmc), count, cmd->opcode);
 		count = 0xE;
 	}
 
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
