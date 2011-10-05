Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab1JEBYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:24:53 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:31829 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab1JEBYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:24:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1317777891!3139823!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 4 Oct 2011 20:24:48 -0500
Subject: RE: [PATCH 11/11] ARM: common/vic: use proper __iomem annotations
Thread-Topic: [PATCH 11/11] ARM: common/vic: use proper __iomem annotations
Thread-Index: AcyAcBBdXrBmMMVKQSuk2MlDE0PKKwCjTx2g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DCFE6DF@AUSP01VMBX24.collaborationhost.net>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
 <1317496920-7764-12-git-send-email-arnd@arndb.de>
In-Reply-To: <1317496920-7764-12-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 01, 2011 12:22 PM, Arnd Bergmann wrote:
> 
> In vic_init, we pass addr into readl, so it needs to be a
> pointer, not a u32 address.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/common/vic.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
> index 7aa4262..adccf6d 100644
> --- a/arch/arm/common/vic.c
> +++ b/arch/arm/common/vic.c
> @@ -347,7 +347,8 @@ void __init vic_init(void __iomem *base, unsigned int irq_start,
>  
>  	/* Identify which VIC cell this one is, by reading the ID */
>  	for (i = 0; i < 4; i++) {
> -		u32 addr = ((u32)base & PAGE_MASK) + 0xfe0 + (i * 4);
> +		void __iomem *addr;
> +		addr = (void __iomem *)((u32)base & PAGE_MASK) + 0xfe0 + (i * 4);
>  		cellid |= (readl(addr) & 0xff) << (8 * i);
>  	}
>  	vendor = (cellid >> 12) & 0xff;

Arnd,

This has already been fixed by Patch 7028/2 in Russell's patch tracking system.

Regards,
Hartley
