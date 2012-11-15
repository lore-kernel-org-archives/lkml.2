Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423538Ab2KOJTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:19:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422860Ab2KOJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:19:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Date: Thu, 15 Nov 2012 09:19:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rob Clark <rob.clark@linaro.org>, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <201211130911.09613.arnd@arndb.de> <20121113112430.GF28341@n2100.arm.linux.org.uk>
In-Reply-To: <20121113112430.GF28341@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211150919.37343.arnd@arndb.de>
X-Provags-ID: V02:K0:7K4uLWyrW41keg4cush7KploAwp/iDLaSlbkwMSRskz
 PZVWKcm+tkjYsHgqeB0VuGFymcxvA1wWrtisrf+TFOxbD8NSWe
 CTZ0He7dv4jkxnmMDPJ+5loarVQy1g5v1QWp3o0Hz3VdCcShqe
 7bCb30qlcOJYaIIVTXmB4T0XumzrZQGX+AzHhL5CyYrzxXA07x
 9HnVB/1cV3WsY+YxJCf40H5yXWhjGwZ9lWTtnDX7kTUFGK4f3d
 5rFCXLlEp5Ua0B9bE3+RGJTstNzb6FRahEZMmcni+SSHI68JZF
 N9//rZdtbaNQrQOrCmwLNIhsDLJvYa7OGe1w2GTqvaQk5E3xWv
 yS6T5y9wgWoz6puWQdcw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012, Russell King - ARM Linux wrote:
> You're missing something; that is one of the greatest powers of open
> source.  The many eyes (and minds) effect.  Someone out there probably
> has a solution to whatever problem, the trick is to find that person. :)
> 
> I think we have a working solution for this for ARM.  It won't be suitable
> for every arch, where they have 8-bit and 16-bit registers able to be
> allocated by the compiler, but for architectures where the minimum register
> size is 32-bit, what we have below should work.

I don't mind at all adding the extension to ARM, and I think it's pretty
cool that you guys actually found a working solution.

The part that worries me is that we are making architecture independent
code depend on a clever hack that may or may not be possible to implement
on a given architecture, and that most architecture maintainers wouldn't
know how to implement correctly even if it's possible.

	Arnd
