Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab0HFKlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:41:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50934 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933047Ab0HFKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:41:22 -0400
Date: Fri, 6 Aug 2010 11:41:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: lrg@slimlogic.co.uk, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix WM8994 LDO enable gpio set when probed
Message-ID: <20100806104120.GD398@rakim.wolfsonmicro.main>
References: <1281060446-399-1-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281060446-399-1-git-send-email-jy0922.shim@samsung.com>
X-Cookie: "Pok pok pok, P'kok!"
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:07:26AM +0900, Joonyoung Shim wrote:
> The enable time needs to enable WM8994 LDO, but WM8994 LDO is enabled
> without the enable time at the probe function. This can cause the
> problem to try i2c operation before LDO is enabled.

> This patch sets to 0 WM8994 LDO enable gpio when probed then if it is
> requested to enable WM8994 LDO, will be enabled by enable interface of
> regulator core with enable time.

That's not what the patch actually does.  It's not changing the GPIO
that is configured at all, it is changing the configuration of the flag
which says if the GPIO has been enabled.  This made it very hard to
follow what you're trying to do here.  The change itself is OK but
please supply a better changelog (actually I think I may just rewrite
the changelog for you and send on a new version to Liam - you'll be CCed
if I do this).

The underlying problem here is that due to the gpiolib API it's not
possible for us to read the status of the GPIO when we inherit it at
startup.  If the GPIO was already high when we started then the current
code is fine, if it was low we don't have the delay.
