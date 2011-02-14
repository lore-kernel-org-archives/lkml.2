Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1BNBF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:05:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:45110 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1BNBFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:05:20 -0500
Date: Mon, 14 Feb 2011 12:04:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: Regression - Xorg start failed
In-Reply-To: <20110214003531.GH9869@sequoia.sous-sol.org>
Message-ID: <alpine.LRH.2.00.1102141203430.12055@tundra.namei.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi> <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com> <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com> <20110214003531.GH9869@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Chris Wright wrote:

> Subject: [PATCH] pci: use security_capable correctly during config space read
> 
> Commit 47970b1 ("pci: use security_capable() when checking capablities
> during config space read") is just plain broken.  The normal capable()
> interface returns true on success, but the LSM interface returns 0 on
> success.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Sorry, I should have caught this.

Acked-by: James Morris <jmorris@namei.org>

> ---
> 
> I've tested this quickly (lspci behaviour is as expected).
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index f7771f3..ea25e5b 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -369,7 +369,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
>  	u8 *data = (u8*) buf;
>  
>  	/* Several chips lock up trying to read undefined config space */
> -	if (security_capable(filp->f_cred, CAP_SYS_ADMIN)) {
> +	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
>  		size = dev->cfg_size;
>  	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>  		size = 128;
> 
> 

-- 
James Morris
<jmorris@namei.org>
