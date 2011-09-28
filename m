Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1I1Wm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab1I1WmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:32 2011
Message-Id: <20110928220132.472925398@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Girish K S <girish.shivananjappa@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [068/244] mmc: sdhci-s3c: Fix mmc card I/O problem
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Girish K S <girish.shivananjappa@linaro.org>

commit 49bb1e619568ec84785ceb366f07db2a6f0b64cc upstream.

This patch fixes the problem in sdhci-s3c host driver for Samsung Soc's.
During the card identification stage the mmc core driver enumerates for
the best bus width in combination with the highest available data rate.
It starts enumerating from the highest bus width (8) to lowest width (1).

In case of few MMC cards the 4-bit bus enumeration fails and tries
the 1-bit bus enumeration. When switched to 1-bit bus mode the host driver
has to clear the previous bus width setting and apply the new setting.

The current patch will clear the previous bus mode and apply the new
mode setting.

Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci-s3c.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -301,6 +301,8 @@ static int sdhci_s3c_platform_8bit_width
 		ctrl &= ~SDHCI_CTRL_8BITBUS;
 		break;
 	default:
+		ctrl &= ~SDHCI_CTRL_4BITBUS;
+		ctrl &= ~SDHCI_CTRL_8BITBUS;
 		break;
 	}
 


