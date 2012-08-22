Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2HVP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:28:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37533 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2HVP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:28:55 -0400
Date: Wed, 22 Aug 2012 11:28:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] [RFC] ARM: mass move of mach-*/plat-* header files
In-Reply-To: <201208221256.35657.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1208221126180.1754@xanadu.home>
References: <201208221253.07278.arnd@arndb.de> <201208221256.35657.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Arnd Bergmann wrote:

> This moves all <mach/*.h> headers to <mach-*/*.h>, and all
> <plat/*.h> headers to <plat-*/*.h>, as another step closer
> to building kernels for multiple platforms combined.
> 
> A script to generate headers with the traditional names including
> the headers from the new place is already there, so this move
> should be completely transparent.
> 
> This patch was created fully automated by a script and
> should be redone if the headers change. Note that the
> plat-mxc headers move to mach-imx in the process because
> they don't follow the <plat/foo.h> naming convention:
> 
> for i in arch/arm/mach-* ; do git mv $i/include/mach $i/include/${i##*/} ; done
> for i in arch/arm/plat-* ; do git mv $i/include/plat $i/include/${i##*/} ; done
> git mv arch/arm/plat-mxc/include/mach/*.h arch/arm/mach-imx/include/mach-imx/
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Nicolas Pitre <nico@linaro.org>

Ideally, files such as ...

> rename from arch/arm/mach-at91/include/mach/at91_pio.h
> rename to arch/arm/mach-at91/include/mach-at91/at91_pio.h

should move next to the A91 GPIO driver file.  but that require manual 
operations which can be done later.


Nicolas
