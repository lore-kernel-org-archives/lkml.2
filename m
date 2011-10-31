Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460Ab1JaMhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 08:37:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49541 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934434Ab1JaMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 08:37:52 -0400
Date: Mon, 31 Oct 2011 12:37:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: wm8711: Add proper mask for wm8711_set_dai_fmt
Message-ID: <20111031123749.GA10217@opensource.wolfsonmicro.com>
References: <1319771281.3944.1.camel@phoenix>
 <1319771527.3944.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319771527.3944.4.camel@phoenix>
X-Cookie: Beware the one behind you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 11:12:07AM +0800, Axel Lin wrote:
> Add mask for BIT[3:2] (the Input Audio Data Bit Length Select)
> of WM8711_IFACE(07h) register.
> Otherwise, BIT[3:2] will be always set to 0b00 here.

Your changelog here isn't terribly clear and doesn't really correspond
to the change well.  Here you say you're masking something but...

> -	u16 iface = 0;
> +	u16 iface = snd_soc_read(codec, WM8711_IFACE) & 0x000c;

...what you're actually doing is preserving the existing values of some
register bits.  Nevertheless the change looks good so applied.
