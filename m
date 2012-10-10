Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2JJGyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:54:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46407 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JJGyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:54:24 -0400
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Porter, Matt" <mporter@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: RE: [PATCH 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Topic: [PATCH 0/2] Convert davinci ASoC to genalloc SRAM
Thread-Index: AQHNpqffLG9GQkGCZEGqausiKS4GCZeyGaAg
Date: Wed, 10 Oct 2012 06:54:12 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412852CA@DBDE01.ent.ti.com>
References: <1349345745-10584-1-git-send-email-mporter@ti.com>
In-Reply-To: <1349345745-10584-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 15:45:43, Porter, Matt wrote:
> This series converts davinci ASoC to use genalloc and enables
> that support on DA850. It applies on top of the uio_pruss/genalloc
> series [1] which allows DaVinci to provide a gen_pool via pdata
> for driver use.
> 
> I've tested this on the AM180x EVM. Note that prior to this,
> the SRAM paths in the driver were completely unused. I've only
> enabled ping-pong buffering on the platform I can test as it's
> best to allow those with DM644x and similar platforms to set the
> playback/capture sram size to something that's known to work
> for them.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg198854.html

Tested on DA850 EVM after applying patches from [1] above.
Tested on Linux-torvalds 3.6-rc6 master branch.
Tested ASoC module (aplay & arecord for various frequencies)

Acked-by: Kumar, Anil <anilkumar.v@ti.com>
 
> Matt Porter (2):
>   ASoC: davinci: replace private sram api with genalloc
>   ARM: davinci: enable SRAM ping ping buffering on DA850
> 
>  arch/arm/mach-davinci/board-da850-evm.c   |   24 ++++++++++++++----------
>  include/linux/platform_data/davinci_asp.h |    3 +++
>  sound/soc/davinci/davinci-mcasp.c         |    2 ++
>  sound/soc/davinci/davinci-pcm.c           |   18 ++++++++++++------
>  sound/soc/davinci/davinci-pcm.h           |    2 ++
>  5 files changed, 33 insertions(+), 16 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

