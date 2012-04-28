Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2D1CFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 22:05:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38831 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2D1CFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 22:05:16 -0400
Date: Fri, 27 Apr 2012 19:05:10 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: xiong <xiong@qca.qualcomm.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 01/10] atl1c: add workaround for issue of bit
 INTX-disable for MSI interrupt
Message-ID: <20120428020510.GJ14465@tux>
References: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
 <1335578325-21326-2-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335578325-21326-2-git-send-email-xiong@qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 09:58:36AM +0800, xiong wrote:
> All supported devices have one issue that msi interrupt doesn't assert
> if pci command register bit (PCI_COMMAND_INTX_DISABLE) is set.
> Add workaround in drivers/pci/quirks.c
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>
> ---
>  drivers/pci/quirks.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 4bf7102..953ec3f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2626,6 +2626,18 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4374,
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
>  			quirk_msi_intx_disable_bug);
>  
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1062,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1063,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x2060,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x2062,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1073,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1083,
> +			quirk_msi_intx_disable_bug);
>  #endif /* CONFIG_PCI_MSI */

Xiong -- just a heads up, I think to backport these then you can
send me patches for compat-wireless to do the work around itself on
the driver on a patch under patches/ you can say create a 
58-drivers-pci-quirks.patch which pathces your driver there.

  Luis
