Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2ACH52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:57:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42048 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2ACH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:57:26 -0500
MIME-Version: 1.0
In-Reply-To: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
Date: Tue, 3 Jan 2012 08:57:26 +0100
Message-ID: <CACRpkdaS7843scS5jwVajMzrUy3c7bSUHMW7n+=fkk6XTEKfDA@mail.gmail.com>
Subject: Re: [PATCH 0/2] add support for partial pin space
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: swarren@nvidia.com, Baohua.Song@csr.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 8:47 AM, Chanho Park <chanho61.park@samsung.com> wrote:

> A pin space of current pinctrl driver always start with zero-based pin
> number. And pins are enumerated from 0 to a max pin number. If there are
> two pins (one is 0, another is 1000), we always enumerate from 0 to 1000
> for just only two pins. This patch enables to start non-zero based pin
> number and to enumerate actually owned pins.
>
> For example, there is a system which has huge(500 or 1000) pins. If muxing
> or controlling pins are small, we just define such small pins instead of
> whole pins.

Seems like you're fixing my code to do what was originally intended :-)

The maxpin member was something I introduced for sparse ranges
which would auto-register "dummy pins" for those not included in the
enumeration.

That doesn't quite work, so was left behind.

I'll try applying the patches and see what happens.

Yours,
Linus Walleij
