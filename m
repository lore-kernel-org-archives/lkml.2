Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab2JYMlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:41:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44348 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2JYMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:41:29 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Oct 2012 14:41:28 +0200
Message-ID: <CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The clock framework has changed somewhat and it's now better to
> invoke clock_prepare_enable() and clk_disable_unprepare() rather
> than the legacy clk_enable() and clk_disable() calls. This patch
> converts the Nomadik Pin Control driver to the new framework.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I was convinced that this is a good change but no regression,
so applied to the devel branch for 3.8.

I also removed the initial clk_prepare() so the reference count
may actually go down to 0 for the GPIO block and the peripheral
cluster eventually gets relaxed.

Thanks!
Linus Walleij
