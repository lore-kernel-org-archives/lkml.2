Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2AGFiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 00:38:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51464 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2AGFiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 00:38:10 -0500
Date: Sat, 7 Jan 2012 13:48:31 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hui Wang <jason77.wang@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20120107054829.GF4790@S2101-09.ap.freescale.net>
References: <20120106120345.8157a839b1c924315d728eea@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120106120345.8157a839b1c924315d728eea@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:03:45PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-imx/mm-imx5.c between commit 9bdd46257ab3 ("ARM: plat-mxc:
> hook special idle handlers to arm_pm_idle") from the arm tree and commit
> 010dc8af8f28 ("ARM: mx5: use generic irq chip pm interface for pm
> functions on") from the arm-soc tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Hi Stephen,

When I was testing this fix on next-20120106, I spotted another compile
error from this file.

  CC      arch/arm/mach-imx/mm-imx5.o
arch/arm/mach-imx/mm-imx5.c:58:24: error: redefinition of ‘mx50_io_desc’
arch/arm/mach-imx/mm-imx5.c:48:24: note: previous definition of ‘mx50_io_desc’ was here
arch/arm/mach-imx/mm-imx5.c:48:24: warning: ‘mx50_io_desc’ defined but not used

The fix could just be removing the duplication.

-- 
Regards,
Shawn


8<----
@@ -53,16 +54,6 @@ static struct map_desc mx50_io_desc[] __initdata = {
 };

 /*
- * Define the MX50 memory map.
- */
-static struct map_desc mx50_io_desc[] __initdata = {
-       imx_map_entry(MX50, TZIC, MT_DEVICE),
-       imx_map_entry(MX50, SPBA0, MT_DEVICE),
-       imx_map_entry(MX50, AIPS1, MT_DEVICE),
-       imx_map_entry(MX50, AIPS2, MT_DEVICE),
-};
-
-/*
