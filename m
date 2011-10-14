Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1JNTDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:03:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45483 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928Ab1JNTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:03:45 -0400
Date: Fri, 14 Oct 2011 20:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: max98095: Convert codec->hw_write to snd_soc_write
Message-ID: <20111014190342.GA2931@opensource.wolfsonmicro.com>
References: <1318563798.9296.1.camel@phoenix>
 <B2150E1E4418E1438554A300EA5040E40DDFD2E54E@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DDFD2E54E@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:40:58AM -0700, Peter Hsiang wrote:
> On Fri, Oct 14, 2011, Axel Lin wrote:
> > codec->hw_write is broken now, convert codec->hw_write to
> > snd_soc_write.

> The hardware has 2 banks of registers sharing a section in I2C register space.
> The 1st bank is the primary one and is cached.  
> The 2nd bank is for loading coefficients only and they do not need cache.
> These coefficients registers are therefore direct writes.
> Changing this to a cached write will overwrite the cache.

Writes to the cached region should be done within a cache_bypass flag to
deal with this.
