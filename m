Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab1GAQPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:15:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35017 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751803Ab1GAQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:15:10 -0400
Date: Fri, 1 Jul 2011 09:15:07 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8731: set the ACTIVE bit if bias ON entered
Message-ID: <20110701161506.GC23784@opensource.wolfsonmicro.com>
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com>
 <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 12:43:54PM +0200, Nicolas Ferre wrote:
> Resuming from a suspend/resume cycle, the ACTIVE bit was not set even if a
> stream had actually been processing.
> Setting this bit at entering SND_SOC_BIAS_ON level will ensure this.

This will set the bit even for analogue bypass paths which don't need
it.  I'd suggest making the active bit a supply widget supplying the DAC
and ADC rather than something open coded, that should do the right thing
I think.
