Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2IURRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:17:54 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:37847 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756632Ab2IURRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com> <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Fri, 21 Sep 2012 22:47:30 +0530
Message-ID: <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA DMAC
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:45 PM, S, Venkatraman <svenkatr@ti.com> wrote:
> On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
>> The EDMA DMAC has a hardware limitation that prevents supporting
>> scatter gather lists with any number of segments. Since the EDMA
>> DMA Engine driver sets the maximum segments to 16, we do the
>> same.
>>
>> Note: this can be removed once the DMA Engine API supports an
>> API to query the DMAC's segment limitations.
>>
>
> I wouldn't want to bind the properties of EDMA to omap_hsmmc as this patch
> suggests. Why don't we have a max_segs property, which when explicitly specified
> in DT, will override the default ?

If you are adventurous, this can be a generic mmc DT binding instead
of restricting it to OMAP.
