Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1JWRPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:15:17 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60834 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JWRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:15:14 -0400
Date: Sun, 23 Oct 2011 19:11:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 4/6] et131x: remove extraneous pci_save_state.
Message-ID: <20111023171150.GD28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_{save, restore}_state are balanced in .suspend and .resume.
They are not used anywhere else in the driver.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2b6ca6a..46de73b 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -5423,7 +5423,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	 * been initialized, just in case it needs to be quickly restored.
 	 */
 	pci_set_drvdata(pdev, netdev);
-	pci_save_state(adapter->pdev);
 out:
 	return rc;
 
-- 
1.7.6.4

