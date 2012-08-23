Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2HWCeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:34:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:43709 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2HWCeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:34:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,297,1344236400"; 
   d="scan'208";a="209061762"
Date: Thu, 23 Aug 2012 10:33:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unable to mount NFSROOT: pcie change breaks e1000?
Message-ID: <20120823023358.GA4924@localhost>
References: <20120823004604.GA2882@localhost>
 <503587F4.3090907@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503587F4.3090907@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 09:31:32AM +0800, Jiang Liu wrote:
> Hi Fengguang,
> 	Could you please help to verify whether following patch
> fixes the issue?

It works! Thank you for the quick fix!

Tested-by: Fengguang Wu <fengguang.wu@intel.com> 

> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f6b491b..fac08f5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -842,6 +842,9 @@ static int pci_save_pcie_state(struct pci_dev *dev)
>         struct pci_cap_saved_state *save_state;
>         u16 *cap;
> 
> +       if (!pci_is_pcie(dev))
> +               return 0;
> +
>         save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
>         if (!save_state) {
>                 dev_err(&dev->dev, "buffer not found in %s\n", __func__);
> 
> On 2012-8-23 8:46, Fengguang Wu wrote:
> > buffer not found
> 
