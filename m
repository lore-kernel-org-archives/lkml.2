Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1JNTKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:10:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38272 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab1JNTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:10:02 -0400
Date: Fri, 14 Oct 2011 20:10:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: ad193x: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111014191000.GB2931@opensource.wolfsonmicro.com>
References: <1318582919.19976.1.camel@phoenix>
 <1318582987.19976.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318582987.19976.2.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 05:03:07PM +0800, Axel Lin wrote:

>  	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
> -	reg = (mute > 0) ? reg | AD193X_DAC_MASTER_MUTE : reg &
> -		(~AD193X_DAC_MASTER_MUTE);
> +	if (mute)
> +		reg |= AD193X_DAC_MASTER_MUTE;
> +	else
> +		reg &= ~AD193X_DAC_MASTER_MUTE;
>  	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);

This is still using snd_soc_read() and snd_soc_write() (though it is a
cleanup).
