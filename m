Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1CJSzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:55:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1CJSzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:55:46 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: Enable ASPM state clearing regardless of policy
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com, mjg@redhat.com
Date: Thu, 10 Mar 2011 11:54:16 -0700
Message-ID: <20110310185351.3394.54996.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2f671e2d allowed us to clear ASPM state when the FADT
tells us it isn't supported, but we don't put this into effect
if the aspm_policy is set to POLICY_POWERSAVE.  Enable the
state to be cleared regardless of policy.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pcie/aspm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 3188cd9..eb8ac5c 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -607,7 +607,7 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
 	 * the BIOS's expectation, we'll do so once pci_enable_device() is
 	 * called.
 	 */
-	if (aspm_policy != POLICY_POWERSAVE) {
+	if (aspm_policy != POLICY_POWERSAVE || aspm_clear_state) {
 		pcie_config_aspm_path(link);
 		pcie_set_clkpm(link, policy_to_clkpm_state(link));
 	}

