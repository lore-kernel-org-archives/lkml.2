Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2JVS2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:28:05 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39846 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2JVS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:28:02 -0400
Date: Mon, 22 Oct 2012 11:27:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/32 v4] MIPS: Alchemy: use the OHCI platform driver
Message-ID: <20121022182758.GA31971@kroah.com>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
 <1349701906-16481-25-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349701906-16481-25-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:11:38PM +0200, Florian Fainelli wrote:
> Convert the Alchemy platform to register the ohci-platform driver, now that
> the ohci-platform driver properly handles the specific ohci-au1xxx resume
> from suspend case.
> 
> This also greatly simplifies the power_{on,off} callbacks and make them
> work on platform device id instead of checking the OHCI controller base
> address like what was done in ohci-au1xxx.c.
> 
> Impacted defconfigs are also updated accordingly to select the OHCI platform
> driver.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
> Changes in v4:
> - rebased against greg's latest usb-next
> 
> No changes in v3
> 
> Changes in v2:
> - updated defconfigs accordingly
> - really instantiate "ohci-platform" instead of "ohci-au1xxx"
> - rebased on top of the latest OHCI HCD changes
> 
>  arch/mips/alchemy/common/platform.c |   35 +++++++++++++++++++++++++++++++++--
>  arch/mips/configs/db1000_defconfig  |    1 +
>  arch/mips/configs/db1200_defconfig  |    1 +
>  arch/mips/configs/db1300_defconfig  |    1 +
>  arch/mips/configs/db1550_defconfig  |    1 +
>  arch/mips/configs/gpr_defconfig     |    1 +
>  arch/mips/configs/mtx1_defconfig    |    1 +
>  arch/mips/configs/pb1100_defconfig  |    1 +
>  arch/mips/configs/pb1500_defconfig  |    1 +
>  arch/mips/configs/pb1550_defconfig  |    1 +

Same issue with the defconfigs in this patch, they aren't around
anymore, so I've removed them from this patch.  If they just moved,
please send a follow-up patch to fix them up.

thanks,

greg k-h
