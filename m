Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab0DPL0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:26:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:54555 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab0DPL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:26:30 -0400
Date: Fri, 16 Apr 2010 13:26:21 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jakob Viketoft <jakob.viketoft@bitsim.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100416112621.GL30801@buzzloop.caiaq.de>
References: <4BC8330E.6000503@bitsim.com>
 <20100416100126.GI30801@buzzloop.caiaq.de>
 <4BC84766.5060208@bitsim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC84766.5060208@bitsim.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:17:58PM +0200, Jakob Viketoft wrote:
> Daniel Mack wrote:
> >On Fri, Apr 16, 2010 at 11:51:10AM +0200, Jakob Viketoft wrote:
> >>The recent addition of (Colibri) PXA3xx specific declarations breaks
> >>the building of the Colibri 270 with similar features.
> >
> >Hmm, I can't see any problem here. Which error did you get? Which boards
> >did you select in your config?
> 
> Hmmm, it appears I was slightly too fast on the trigger there. I
> encountered the problem some time ago when migrating fron 2.6.29 to
> 2.6.33.1 and a quick look made me think there was a linking problem.
> I'm finishing up this project now and wanted to push any relevant
> fixes upstream. However, the problem I seem to be getting is
> something different though:
> 
>   CC      drivers/pcmcia/pxa2xx_colibri.o
> In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
> arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')'
> before '*' token
> make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
> make[1]: *** [drivers/pcmcia] Error 2
> make: *** [drivers] Error 2

It seems that mfp_cfg_t is unknown. Does including <mach/mfp.h> from
pxa2xx_colibri.c help? However, I can't see any problem on 2.6.34-rc4,
with or without CONFIG_MMC set, so that might only be related to 2.6.33.
Any change of trying this on a cutting edge tree, just to make sure?

Daniel
