Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2IQSQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:16:51 -0400
Received: from bosmailout03.eigbox.net ([66.96.189.3]:36535 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab2IQSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:16:49 -0400
X-Greylist: delayed 5143 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 14:16:49 EDT
X-Authority-Analysis: v=2.0 cv=V8rKJ5bi c=1 sm=1
 a=+IiCBqF6PVcGMu4tpe0iLA==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=Vei7A3t7nWYA:10 a=8nJEP1OIZ-IA:10 a=uZyhaqkQpUgA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=DQF_6Zp4IKdTROBCDEUA:9 a=wPNLvfGTeEIA:10
 a=wx0GOVZTcu8EuaXTIXj3VQ==:117
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: 0Gr21k02W0FdZ9W01Gr27Z
Message-ID: <505754DB.2030801@yahoo.es>
Date: Tue, 18 Sep 2012 00:50:35 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] dw_dmac: introduce autoconfiguration
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.61.7
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/2012 3:39 PM, Andy Shevchenko wrote:
> Here is a patchset that allows to adapt the driver to the hardware
> configuration during probe time. The hardware should have the specific optional
> parameters enabled. Otherwise the driver will consider values stored in the
> platform data.
>
> Additionally it brings support of the software LLP transfers. It means that
> normal linked list transfer is substituted by set of single block transfers
> transparently to the user.
>
> Comments are welcome.
>
> Andy Shevchenko (7):
>   dw_dmac: mark dwc_dump_chan_regs as inline
>   dw_dmac: fill optional encoded parameters in register structure
>   dw_dmac: get number of channels from hardware if possible
>   dw_dmac: autoconfigure block_size or use platform data
>   dw_dmac: autoconfigure data_width or get it via platform data
>   dw_dmac: check if controller supports LLP
>   dw_dmac: introduce software emulation of LLP transfers
>
>  arch/arm/mach-spear13xx/spear13xx.c |    3 +
>  arch/avr32/mach-at32ap/at32ap700x.c |    3 +
>  drivers/dma/dw_dmac.c               |  207 +++++++++++++++++++++++++++++------
>  drivers/dma/dw_dmac_regs.h          |   48 ++++++++
>  include/linux/dw_dmac.h             |    7 ++
>  5 files changed, 235 insertions(+), 33 deletions(-)
Thanks a lot Andy,

I will soon test these patches on my avr32 platform and make a separate
patch for the 'configurable' endianness. I'm sure this can also be detected
automatically but at the cost of performance

Hein

