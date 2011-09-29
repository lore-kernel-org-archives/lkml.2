Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1I2KeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:34:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53296 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab1I2KeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:34:15 -0400
Date: Thu, 29 Sep 2011 11:34:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Subject: Re: [PATCH 1/2] ASoC: Add BUG() assertion if max98088_get_channel
 returns -EINVAL
Message-ID: <20110929103413.GK3697@opensource.wolfsonmicro.com>
References: <1317218471.8008.3.camel@phoenix>
 <4E83AA77.9040700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E83AA77.9040700@gmail.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 09:15:03AM +1000, Ryan Mallon wrote:
> On 29/09/11 00:01, Axel Lin wrote:
> > The callers use the return value of max98088_get_channel as array index to
> > access max98088->dai[] array.
> > Add BUG() assertion for out of bound access of max98088->dai[] array.

> BUG() is pretty heavy handed for a driver. Why not fix the problem
> properly in the callers?

There's nothing constructive that any of the callers can do with an
error code - it's a clear bug in something (probably the driver) if we
get called for a bad control.  Simply returning an error code isn't
terribly helpful, it's very obscure what's gone wrong and why.  We at
least need a log message.
