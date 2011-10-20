Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1JTRKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:10:45 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:40224 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab1JTRKo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <1319121769.24621.130.camel@matrix>
References: <1319121769.24621.130.camel@matrix>
Date: Thu, 20 Oct 2011 18:10:41 +0100
Message-ID: <CABS+qY3zsuQSE_9=_jaoO=AYRyopZ3WPNeG-PJYzwucmWxcqkA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v7 2/3] ASoC: da7210: Add support for line
 out and DAC
From: "Girdwood, Liam" <lrg@ti.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 15:42, Ashish Chavan <ashish.chavan@kpitcummins.com> wrote:
> DA7210 has three line outputs. OUT1 Left, OUT1 Right and OUT2 (mono).
> This patch adds support for gain controls for these three line outs.
> It also adds support for overall DAC gain control.
>
> Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> ---
> Changes since v1:
> - Removed explicit setting of default gains
> - Renamed "DAC Playback" to "Digital Playback"
> ---
>  sound/soc/codecs/da7210.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
>

>
> +       /* Enable Line out amplifiers */
> +       snd_soc_write(codec, DA7210_OUT1_L, DA7210_OUT1_L_EN);
> +       snd_soc_write(codec, DA7210_OUT1_R, DA7210_OUT1_R_EN);
> +       snd_soc_write(codec, DA7210_OUT2, DA7210_OUT2_EN |
> +                    DA7210_OUT2_OUTMIX_L | DA7210_OUT2_OUTMIX_R);
> +

Any reason for not using DAPM here ? Otherwise they are always on
making your chip burn mW.....

Thanks

Liam
