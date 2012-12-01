Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2LAMIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 07:08:42 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:35864 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2LAMIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 07:08:41 -0500
Date: Sat, 1 Dec 2012 12:44:01 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Wang YanQing <udknight@gmail.com>, nic_swsd@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3]realtek:r8169: Bugfix or workaround for missing extended GigaMAC registers settings
Message-ID: <20121201114401.GA3989@electric-eye.fr.zoreil.com>
References: <20121130232152.GA10960@udknight>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130232152.GA10960@udknight>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang YanQing <udknight@gmail.com> :
[...]
> @@ -6903,6 +6903,14 @@ rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev->dev_addr[i] = RTL_R8(MAC0 + i);
>  	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
>  
> +	/*
> +	 *This is a fix for BIOS forget to set
> +	 *extend GigaMAC registers
> +	 *Wang YanQing 12/1/2012
> +	 */

This part will go into the changelog.

> +	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> +	    rtl_rar_set(tp, dev->dev_addr);
> +	}

rtl_rar_set already includes a RTL_GIGA_MAC_VER_34 test and non-8168evl
devices are already able to stand an extra MAC{0, 4} write. I'll check
it does not hurt on different 81xx devices and submit an update.

Thanks.

-- 
Ueimor
