Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab2K3La2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:30:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52488 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2K3La0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:30:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org
In-Reply-To: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
Date: Fri, 30 Nov 2012 11:30:21 +0000
Message-Id: <20121130113021.67D3A3E14C4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012 14:20:55 +0200, Drasko DRASKOVIC <drasko.draskovic@gmail.com> wrote:
> Hi all,
> please find a patch that adds IRQ edge set-up mechanism to sysfs that
> can be called from the kernel.
> 
> This functionality can be very useful for embedded systems, as it
> permits kernel to do GPIO set-up during boot stage. Configuration
> which defines pins behavior is often kept in NVRAM, and during boot
> stage these structures can be parsed and executed by the kernel, so
> that when user processes already find all sysfs environment ready and
> correctly set-up.
> 
> While at the present it is possible to export GPIO pins to sysfs (and
> correct direction / value), it is not possible to export IRQ
> configuration as well, so this must be done in user space (most often
> via command line). this patch implements missing functionality, so
> that  gpio_sysfs_set_edge() function can be called directly from the
> kernel.

This really seems like the wrong place to be doing this. If the GPIO
needs to be used with a particular configuration for an IRQ, then the
device tree or platform data on non-dt should be given that information.
I do not feel good about exporting anonymnous IRQ configuration to
userspace.
