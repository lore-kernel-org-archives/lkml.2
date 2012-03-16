Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946056Ab2CPXj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:39:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38586 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946080Ab2CPXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:53 -0400
Message-Id: <20120316233811.136320350@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 4949be16822e92a18ea0cc1616319926628092ee upstream.

Right now we won't touch ASPM state if ASPM is disabled, except in the case
where we find a device that appears to be too old to reliably support ASPM.
Right now we'll clear it in that case, which is almost certainly the wrong
thing to do. The easiest way around this is just to disable the blacklisting
when ASPM is disabled.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aspm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct
 	int pos;
 	u32 reg32;
 
+	if (aspm_disabled)
+		return 0;
+
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot


