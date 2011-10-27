Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1J0Lw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 07:52:58 -0400
Received: from bitmer.com ([213.157.87.50]:33267 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab1J0Lw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 07:52:57 -0400
Subject: Re: [PATCH 2/2] ASoC: tlv320aic3x: Clear BIT_CLK_MASTER and
 WORD_CLK_MASTER bits for for slave mode
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1319704722.2673.5.camel@phoenix>
References: <1319704549.2673.2.camel@phoenix>
	 <1319704722.2673.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 13:52:21 +0200
Message-ID: <1319716341.4629.10.camel@puukko.homenet-68>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 16:38 +0800, Axel Lin wrote:
> According to the datasheet:
> 
> Page0 / Register8: Audio Serial Data interface Control Register A
> BIT 7: Bit Clock Directional Control
>         0: Bit clock is an input (slave mode)
>         1: Bit clock is an output (master mode)
> 
> BIT 6: Word Clock Directional Control
>         0: Word clock is an input (slave mode)
>         1: Word clock is an output (master mode)
> 
> Current code sets BIT_CLK_MASTER and WORD_CLK_MASTER bits for master mode,
> but does not clear these bits for slave mode.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/tlv320aic3x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
This is not entirely true - there is this fussy '& 0x3f' operation that
does clear those bits a few code lines above your change. Now we can rid
of it thanks to your patch, hopefully for iface_breg too (in case if you
are going to send an another patch as this is applied) :-)

-- 
Jarkko

