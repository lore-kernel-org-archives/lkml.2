Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947133Ab2LFUTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:19:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60397 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947046Ab2LFUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com>
	<1354779918-4028-2-git-send-email-acourbot@nvidia.com>
Date: Thu, 6 Dec 2012 21:19:47 +0100
Message-ID: <CACRpkdY3mJL00e0Yq7RBRyHxR9AKMTj7um4Upq3Mh2kxMPqdww@mail.gmail.com>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 8:45 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> With the current API, GPIOs are manipulated through an integer which
> represents their unique number across the system. This poses problems in
> terms of portability, scalability and flexibility: for instance, the
> number of valid GPIOs for a given system is fixed at system time, and a
> large array of that size is statically allocated to hold the GPIO
> descriptors. Worse, GPIOs can be used without being properly allocated.
>
> In order to improve the situation, the integer namespace must first get
> away. This patch introduces an alternative GPIO API that uses opaque
> handlers and refactor gpiolib's internals to work with these handlers
> instead of GPIO numbers. The former integer-based API is still available
> as a light wrapper around this new API.
>
> This first step will then us to build more improvements for gpiolib,
> like proper GPIO lookup functions per device and provider, and getting
> rid of the static GPIO array and the ARCH_NR_GPIO configuration option.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I really like this. It is looking very good.

Especially it's nice that it makes GPIO descriptors the norm
rather than a bolt-on, and the old linear GPIO space is turned
into a comaptibility layer using static inlines.

I'd like to see some love for Documentation/gpio.txt to reflect
the changes, plus considering Grants note, and I will be happy
to add Reviewed-by on this.

Especially the lookups will be nice to see going forward!

Yours,
Linus Walleij
