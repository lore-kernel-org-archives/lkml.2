Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1LIX4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:56:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58894 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1LIXz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17518604D7@HQMAIL01.nvidia.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
	<1323382390-14892-2-git-send-email-swarren@nvidia.com>
	<CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17518604D7@HQMAIL01.nvidia.com>
Date: Sat, 10 Dec 2011 00:55:58 +0100
Message-ID: <CACRpkdahqb0qMVcKF9NBT5pwRgK4FOob5ABtb7ids9Bhh5XbZg@mail.gmail.com>
Subject: Re: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 6:28 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Hence, there's no point parsing it from device tree; we end up with exactly
> the same data in the driver, yet have spent a bunch of time parsing it out
> from device tree instead of just embedding it into the kernel binary.

For me there are two points:

- Avoiding clash with kernel maintainers who hate firmware-like tables and
  binary data filling up the kernel. Some certain other guy bearing my
  name comes to mind.

- Footprint: the majority of the stuff in your driver ends up in non-discardable
  memory, and will be kept around. Since we have this concept of a
  single zImage for a number of say ARMv7 systems, and since pin
  controllers can be pretty hard to load from modules, *all* of them
  may have to be compiled-in. If every driver for every board takes this
  approach I am afraid it will be end up with a measurable footprint.

Yours,
Linus Walleij
