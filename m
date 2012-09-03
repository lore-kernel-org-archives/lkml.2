Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2ICJLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:11:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34133 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2ICJLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <1346660069-16049-1-git-send-email-stigge@antcom.de>
References: <1346660069-16049-1-git-send-email-stigge@antcom.de>
Date: Mon, 3 Sep 2012 11:11:14 +0200
Message-ID: <CACRpkdZ75s-yh5vzevbUPzhGbOj+mBNfJ+i68f5tH67oS4X__A@mail.gmail.com>
Subject: Re: [PATCH] spi/pl022: Fix chipselects pointer computation
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>, broonie@opensource.wolfsonmicro.com
Cc: shiraz.linux.kernel@gmail.com, aletes.xgr@gmail.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 10:14 AM, Roland Stigge <stigge@antcom.de> wrote:

> The new chip select handling via GPIO introduced a pointer computation bug:
>
>         (int *) pl022 + sizeof(struct pl022)
>
> doesn't point to the data immediately after the actual struct pl022 (as was
> intended) but to a multiple of bytes after it because of the (int *) type.
>
> Replacing the kludgy pointer arithmetic with managed memory allocation for the
> chip selects.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for fixing this! And thanks to Shiraz for spotting the problem,
Mark you could add a:

Reported-by: Shiraz Hashim <shiraz.linux.kernel@gmail.com>

when applying this.

Yours,
Linus Walleij
