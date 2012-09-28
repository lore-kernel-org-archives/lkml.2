Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab2I1TFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:05:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab2I1TE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Brian Cockrell <brian.cockrell@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 210/262] iwlwifi: dont double free the interrupt in failure path
Date: Fri, 28 Sep 2012 11:52:19 -0700
Message-Id: <20120928183022.905697432@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a7be50b7e30f9d77cb059a7ffdb781bb0fb92eba upstream.

When the driver can't get the HW ready, we would release
the interrupt twice which made the kernel complain loudly.

Reported-by: Brian Cockrell <brian.cockrell@intel.com>
Tested-by: Brian Cockrell <brian.cockrell@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1437,6 +1437,7 @@ static int iwl_trans_pcie_start_hw(struc
 	return err;
 
 err_free_irq:
+	trans_pcie->irq_requested = false;
 	free_irq(trans_pcie->irq, trans);
 error:
 	iwl_free_isr_ict(trans);


