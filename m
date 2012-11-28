Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2K1RKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:10:17 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:43809 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2K1RKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:10:15 -0500
Message-ID: <1354122607.6612.6.camel@trivette.mtl.sfl>
Subject: Re: [PATCH] ARM: davinci: da8xx_register_spi() should not register
 SPI board info
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Nov 2012 12:10:07 -0500
In-Reply-To: <50B5CFFE.7010701@ti.com>
References: <1347323353-19764-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <50B5CFFE.7010701@ti.com>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Wed, 2012-11-28 at 14:19 +0530, Sekhar Nori wrote:
> Hi Vivien,
> 
> On 9/11/2012 5:59 AM, Vivien Didelot wrote:
> > Without this patch, da8xx_register_spi() registers the SPI board info,
> > the SPI controller, and sets its number of chipselect to the size of the
> > static spi_board_info array. This is bad because a SPI board info may
> > declare devices for different SPI buses, and because other code can also
> > call spi_register_board_info() (e.g. a daughter board might provide
> > additional SPI devices).
> > 
> > This patch removes the spi_register_board_info() call from
> > da8xx_register_spi(), renames this last one to da8xx_register_spi_bus()
> > to be more explicit, takes the number of chipselect as a function
> > parameter, and updates the impacted board-da8{3,5}0-evm.c, and
> > board-mityomapl138.c files accordingly. It also sets the SPI platform
> > data static, as it doesn't need to be exported.
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> 
> Sorry about the late reply. It seems I missed seeing this completely
> until you reminded Kevin about it.
> 
> The patch looks good to me except some minor issues. I made those
> changes myself locally since I am the one guilty of getting back on this
> so late. See below:
> 
> > ---
> >  arch/arm/mach-davinci/board-da830-evm.c    |  9 +++++++--
> >  arch/arm/mach-davinci/board-da850-evm.c    |  9 +++++++--
> >  arch/arm/mach-davinci/board-mityomapl138.c |  9 +++++++--
> >  arch/arm/mach-davinci/devices-da8xx.c      | 14 +++-----------
> >  arch/arm/mach-davinci/include/mach/da8xx.h |  3 +--
> >  5 files changed, 25 insertions(+), 19 deletions(-)
> 
> The patch doesn't apply to the latest kernel anymore. I resolved that.
> 
> > 
> > diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
> > index 11c3db9..adb8d87 100644
> > --- a/arch/arm/mach-davinci/board-da830-evm.c
> > +++ b/arch/arm/mach-davinci/board-da830-evm.c
> > @@ -652,8 +652,13 @@ static __init void da830_evm_init(void)
> >  	if (ret)
> >  		pr_warning("da830_evm_init: rtc setup failed: %d\n", ret);
> >  
> > -	ret = da8xx_register_spi(0, da830evm_spi_info,
> > -				 ARRAY_SIZE(da830evm_spi_info));
> > +	ret = spi_register_board_info(da830evm_spi_info,
> > +				      ARRAY_SIZE(da830evm_spi_info));
> > +	if (ret)
> > +		pr_warning("da830_evm_init: spi info registration failed: %d\n",
> > +			   ret);
> 
> Checkpatch asks us to use pr_warn() instead. Fixed that. Also, used
> __func__ to print function name. Rob Tivy has patches fixing these all
> through this file.
> 
> Thanks,
> Sekhar

Thank you for considering the patch and for the upstream update!

Cheers,
Vivien


