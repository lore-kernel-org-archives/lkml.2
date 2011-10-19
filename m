Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1JSOp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:45:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1JSOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:45:56 -0400
Date: Wed, 19 Oct 2011 15:45:51 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gregkh@suse.de,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 6/6] mach-ux500: remove intermediary add_platform_device*
 functions
Message-ID: <20111019144551.GA4829@totoro>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <1318852378-14180-7-git-send-email-lee.jones@linaro.org>
 <20111017115908.GE4992@totoro>
 <4E9EE1F8.7060207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9EE1F8.7060207@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 03:43:04PM +0100, Lee Jones wrote:
> On 17/10/11 12:59, Jamie Iles wrote:
> > Hi Lee,
> > 
> > On Mon, Oct 17, 2011 at 12:52:58PM +0100, Lee Jones wrote:
[...]
> >> diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
> >> index f8adff8..089371e 100644
> >> --- a/arch/arm/mach-ux500/devices-common.h
> >> +++ b/arch/arm/mach-ux500/devices-common.h
> > [...]
> >> -static inline struct platform_device *
> >> -dbx500_add_msp_i2s(int id, resource_size_t base, int irq,
> >> -		   struct msp_i2s_platform_data *pdata)
> >> -{
> >> -	return dbx500_add_platform_device_4k1irq("MSP_I2S", id, base, irq,
> >> -						 pdata);
> >> +	struct resource resources[] = {
> >> +		DEFINE_RES_MEM(base, SZ_4K),
> >> +		DEFINE_RES_IRQ(irq),
> >> +	};
> >> +
> >> +	return platform_device_register_resndata(parent, "nmk-i2c",
> >> +						 id, resources,
> >> +						 ARRAY_SIZE(resources),
> >> +						 pdata, sizeof(*pdata));
> >>  }
> > 
> > I think you need platform_device_register_full() rather than 
> > platform_device_register_resndata() here as dbx500_add_platform_device() 
> > also set a dma mask which platform_device_register_resndata() doesn't 
> > do.  Otherwise a nice diffstat!
> 
> Good spot.
> 
> I can't seem to find platform_device_register_full(). Does it exist?

Yes, but it's in linux-next rather than Linus' tree (new helper to 
create platform devices with dma mask).

Jamie
