Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2HWPDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:03:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HWPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:03:41 -0400
Message-ID: <50364641.8010000@gmail.com>
Date: Thu, 23 Aug 2012 23:03:29 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unable to mount NFSROOT: pcie change breaks e1000?
References: <20120823004604.GA2882@localhost> <503587F4.3090907@huawei.com>
In-Reply-To: <503587F4.3090907@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
	Could you please help to fold this small patch into 
"[5/40] PCI/core: Use PCI Express Capability accessors"?
It fixes a bug reported by Fengguang.
	Thanks!
	Gerry

On 08/23/2012 09:31 AM, Jiang Liu wrote:
> Hi Fengguang,
> 	Could you please help to verify whether following patch
> fixes the issue?
> 	Thanks!
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
>> buffer not found
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

