Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1K1T7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:59:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33475 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab1K1T7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:59:47 -0500
Date: Mon, 28 Nov 2011 20:59:39 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: stable-3.1: iwlwifi broken with nomsi
Message-ID: <20111128195939.GA15362@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 

I believe commit 63665158282dd3b5d70 (iwlwifi: allow pci_enable_msi fail)
needs to be added to the 3.1 stable tree as the driver fails to probe
with MSI disabled since commit 084dd79172cb3 (iwlagn: move PCI related
operations from probe and remove to PCI layer) without it:

[    2.564901] iwlagn 0000:0e:00.0: PCI INT A -> GSI 18 (level, low) ->
IRQ 18
[    2.564962] iwlagn 0000:0e:00.0: setting latency timer to 64
[    2.564977] iwlagn 0000:0e:00.0: pci_resource_len = 0x00002000
[    2.567136] iwlagn 0000:0e:00.0: pci_resource_base = f8038000
[    2.569274] iwlagn 0000:0e:00.0: HW Revision ID = 0x0
[    2.571375] iwlagn 0000:0e:00.0: pci_enable_msi failed
[    2.571431] iwlagn 0000:0e:00.0: PCI INT A disabled
[    2.575598] iwlagn: probe of 0000:0e:00.0 failed with error -1

The problem was initially reported here:

	https://lkml.org/lkml/2011/10/26/314

but the fix was never marked for stable.

Thanks,
Johan
