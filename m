Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2INIEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:04:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46771 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab2INIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:03:53 -0400
Date: Fri, 14 Sep 2012 09:03:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: arnd@arndb.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120914080347.GB3374@gmail.com>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdaKa=NAObnjJyifhxyqu3Hcgj7Fxqi=bdNFqbm7V_8cSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaKa=NAObnjJyifhxyqu3Hcgj7Fxqi=bdNFqbm7V_8cSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:35:43AM +0200, Linus Walleij wrote:
> On Mon, Aug 6, 2012 at 2:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > If we're booting with Device Tree enabled, we want the IRQ numbers to
> > be taken and translated from the Device Tree binary. If not, they
> > should be taken from the resource allocation defined in the AB8500 MFD
> > core driver.
> >
> > Tested-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Not having this patch in v3.6-rcN gives the following boot noise (and
> the key does not work):
> 
> ------------[ cut here ]------------
> WARNING: at /home/elinwal/linux-stericsson/kernel/irq/irqdomain.c:137
> irq_domain_legacy_revmap+0x20/0x48()
> Modules linked in:
> [<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c001d37c>]
> (warn_slowpath_common+0x4c/0x64)
> [<c001d37c>] (warn_slowpath_common+0x4c/0x64) from [<c001d3b0>]
> (warn_slowpath_null+0x1c/0x24)
> [<c001d3b0>] (warn_slowpath_null+0x1c/0x24) from [<c0064200>]
> (irq_domain_legacy_revmap+0x20/0x48)
> [<c0064200>] (irq_domain_legacy_revmap+0x20/0x48) from [<c02cea28>]
> (ab8500_ponkey_probe+0xd0/0x1f8)
> [<c02cea28>] (ab8500_ponkey_probe+0xd0/0x1f8) from [<c01a1e20>]
> (platform_drv_probe+0x14/0x18)
> [<c01a1e20>] (platform_drv_probe+0x14/0x18) from [<c01a0be4>]
> (driver_probe_device+0x78/0x208)
> [<c01a0be4>] (driver_probe_device+0x78/0x208) from [<c01a0e00>]
> (__driver_attach+0x8c/0x90)
> [<c01a0e00>] (__driver_attach+0x8c/0x90) from [<c019f514>]
> (bus_for_each_dev+0x50/0x7c)
> [<c019f514>] (bus_for_each_dev+0x50/0x7c) from [<c01a0424>]
> (bus_add_driver+0x170/0x23c)
> [<c01a0424>] (bus_add_driver+0x170/0x23c) from [<c01a12b4>]
> (driver_register+0x78/0x144)
> [<c01a12b4>] (driver_register+0x78/0x144) from [<c0008598>]
> (do_one_initcall+0x34/0x174)
> [<c0008598>] (do_one_initcall+0x34/0x174) from [<c03df8e8>]
> (kernel_init+0xfc/0x1bc)
> [<c03df8e8>] (kernel_init+0xfc/0x1bc) from [<c000f1d4>]
> (kernel_thread_exit+0x0/0x8)
> ---[ end trace d77aa0db848f0e28 ]---
> ab8500-core ab8500-core.0: Failed to request dbf IRQ#0: -22
> ab8500-poweron-key: probe of ab8500-poweron-key.0 failed with error -22
> 
> So how do we proceed to not release v3.6 with this regression?
> 
> Shall all of the MFD IRQdomain stuff be pulled into the -rc series?
> 
> (Linux-next seems to be working, so the real fix is in there)

I haven't tested this, but I think this patch should be pulled out
of -next and pushed into the -rcs to fix the issue you see above.
The real fix along with the revert to this patch also resides in
-next and will be applied during the next merge window.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
