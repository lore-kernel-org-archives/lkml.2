Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2DSSfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:35:47 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43539 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038Ab2DSSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:35:46 -0400
Message-ID: <1334860536.4452.0.camel@odin>
Subject: Re: [PATCH] regulator: core: Optimise enable/disable path for
 always on regulators
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org
Date: Thu, 19 Apr 2012 19:35:36 +0100
In-Reply-To: <1334838618-27924-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334838618-27924-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 13:30 +0100, Mark Brown wrote:
> If a regulator is always on for any reason then cache that when the
> consumer is created and use it to optimise away the need to take locks
> or recurse up the supply tree when consumers do enable or disable calls.
> The scheduling of asynchronous work for bulk enables is also skipped.
> 
> We don't actually check if the device physically supports control on the
> basis that constraints allowing status changes on physically always on
> regulators are nonsensical anyway.
> 
> This is a very common pattern in hardware - it's normal to have some
> power supplies that have either no software control or are critical to
> system function - so many systems should be able to benefit.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Acked-by: Liam Girdwood <lrg@ti.com>

