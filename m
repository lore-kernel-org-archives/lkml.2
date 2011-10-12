Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1JLOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:53:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34846 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab1JLOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:53:12 -0400
Date: Wed, 12 Oct 2011 15:53:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg@ti.com, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        kuninori.morimoto.gx@renesas.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 2/9] ASoC: da7210: Add support for line
 input and mic
Message-ID: <20111012145310.GO3647@opensource.wolfsonmicro.com>
References: <1318431492.12107.403.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318431492.12107.403.camel@matrix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:28:12PM +0530, Ashish Chavan wrote:

> +static const char *da7210_mic_bias_voltage_txt[] = {
> +	"1.5", "1.6", "2.2", "2.3"
> +};
> +
> +static const struct soc_enum da7210_mic_bias =
> +	SOC_ENUM_SINGLE(DA7210_MIC_L, 4, 4, da7210_mic_bias_voltage_txt);
> +

This shouldn't be application controllable, it's a board property and if
it needs to be managed it's likely to be by in kernel things like
accessory detection.  We do have some older drivers that do this but
they're not good.  Use platform data.
