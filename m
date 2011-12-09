Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1LIXtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:49:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41680 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1LIXtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <20111209170722.GO31337@atomide.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
	<1323382390-14892-2-git-send-email-swarren@nvidia.com>
	<CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
	<20111209170722.GO31337@atomide.com>
Date: Sat, 10 Dec 2011 00:49:11 +0100
Message-ID: <CACRpkdaco=967cKHUcj9VNKc_HyT7Mw30Z9HVdfgsUsHbps8bQ@mail.gmail.com>
Subject: Re: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 6:07 PM, Tony Lindgren <tony@atomide.com> wrote:

> - We currently have hard time supporting pin groups with pins
>  coming from multiple pinmux driver instances

Pin groups are per definiton per-controller inctance. That is a
given side effect of not having a global pin space.

But you can create two groups of the same name on two
pin controllers so that e.g. pinctrl.0 and pinctrl.1 have
a group named "foo", then map both to a certain device
in the board pinmux map.

You will have to request them individually however, like
with two hogs or two pinmux_get() calls specifying the
name of each map, else you will just get the first one.

Not that I've tried it, but that's how it's supposed to work...

Yours,
Linus Walleij
