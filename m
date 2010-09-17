Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0IQM2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:28:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46093 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752829Ab0IQM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:28:46 -0400
Date: Fri, 17 Sep 2010 13:28:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] Regulator: lp3972 cleanup
Message-ID: <20100917122844.GD4322@rakim.wolfsonmicro.main>
References: <1284702257.9481.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284702257.9481.3.camel@mola>
X-Cookie: I can't drive 55.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 01:44:17PM +0800, Axel Lin wrote:

>  - Logging the value for diagnostics if failed to detect device

>  	if (ret == 0 && (val & SYS_CONTROL1_INIT_MASK) != SYS_CONTROL1_INIT_VAL)
>  		ret = -ENODEV;
>  	if (ret < 0) {
> -		dev_err(&i2c->dev, "failed to detect device\n");
> +		dev_err(&i2c->dev, "failed to detect device: %d\n", ret);

This misses part of the point of my suggestion - if you don't match the
ID register then you'll log -ENODEV rather than the device ID that you
read back which would presumably be more useful for someone trying to
work out why the check triggered.

Lots of other good stuff in there, though:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
