Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2HWBbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 21:31:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64293 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2HWBbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 21:31:52 -0400
Message-ID: <503587F4.3090907@huawei.com>
Date: Thu, 23 Aug 2012 09:31:32 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unable to mount NFSROOT: pcie change breaks e1000?
References: <20120823004604.GA2882@localhost>
In-Reply-To: <20120823004604.GA2882@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,
	Could you please help to verify whether following patch
fixes the issue?
	Thanks!

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f6b491b..fac08f5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -842,6 +842,9 @@ static int pci_save_pcie_state(struct pci_dev *dev)
        struct pci_cap_saved_state *save_state;
        u16 *cap;

+       if (!pci_is_pcie(dev))
+               return 0;
+
        save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
        if (!save_state) {
                dev_err(&dev->dev, "buffer not found in %s\n", __func__);

On 2012-8-23 8:46, Fengguang Wu wrote:
> buffer not found


