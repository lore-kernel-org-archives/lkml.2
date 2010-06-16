Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0FPHni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:43:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57661 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753493Ab0FPHng convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:43:36 -0400
Subject: Re: [PATCH v2] soc/sh: Fix I2C dependency for SND_FSI_AK4642 and SND_FSI_DA7210
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100616035440.GA29614@linux-sh.org> (sfid-20100616_045500_015014_5B5A79AE)
Date: Wed, 16 Jun 2010 08:43:33 +0100
Cc: Peter Huewe <PeterHuewe@gmx.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-sh@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <250A6DE6-BB14-42F7-9500-A479C8FCA9B3@opensource.wolfsonmicro.com>
References: <201006141739.42346.PeterHuewe@gmx.de> <201006151649.07554.PeterHuewe@gmx.de> <20100615151913.GJ14510@rakim.wolfsonmicro.main> <201006151738.56143.PeterHuewe@gmx.de> <20100616035440.GA29614@linux-sh.org> (sfid-20100616_045500_015014_5B5A79AE)
To: Paul Mundt <lethal@linux-sh.org>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jun 2010, at 04:54, Paul Mundt wrote:

> On Tue, Jun 15, 2010 at 05:38:55PM +0200, Peter Huewe wrote:
>> The config option SND_FSI_AK4642 selects SND_SOC_AK4642 which in turn
>> enables the compilation of ak4642.c - however this codec uses I2C to
>> communicate with the HW.
>> Same applies to DA7210.

> It uses I2C, but it doesn't matter which I2C master it's interfaced with.
> A simple depends on I2C will suffice for this purpose just fine.

Since these are board specific drivers they know which I2C controller they are
hooked up to and so can usefully depend on a specific controller - without the
correct controller driver they will not function.