Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0LBPTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:19:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab0LBPTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:19:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pk3EHwQg9n65AcQQI9J4fYrGOm87oX9aYRHOO3PuqOYjBuWgMN7gj+uEWTXg71WdXo
         HXeXyfQhH8xYGoc/WZY88iahd97mVV9y7mN3lc5yLOGJ5pEXktVABOROnfTcKAnko5mt
         r7fnW0FRUJHj2xLla00BkbWU7D61rnuPdx4Hc=
MIME-Version: 1.0
In-Reply-To: <20101201002527.GC14383@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
	<20101130171658.GA24034@oksana.dev.rtsoft.ru>
	<20101130233204.GB14383@n2100.arm.linux.org.uk>
	<20101201002527.GC14383@n2100.arm.linux.org.uk>
Date: Thu, 2 Dec 2010 15:19:05 +0000
X-Google-Sender-Auth: 1kNdglNgUAY7YUgCHzJFkUrjODw
Message-ID: <AANLkTikpjq-8BVanF5W76j0ZdDBur8DyHWSH8GGgJBQs@mail.gmail.com>
Subject: Re: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU bootup
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Jamie Iles <jamie.iles@picochip.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2010 00:25, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 30, 2010 at 11:32:04PM +0000, Russell King - ARM Linux wrote:
>> Note that I'll go with factoring this out into arch/arm/kernel/smp_scu.c
>> for the time being, but I'm not convinced about the other parts yet.
>
> IOW, something like the attached.  I've gone a little further and removed
> the now unnecessary scu_enable() and scu_get_core_count() global functions,
> making scu_enable() static, and eliminating scu_get_core_count() entirely.

There is some benefit in leaving get_core_count() in the platform
code. For example, the SCU on Cortex-A15 doesn't expose the core count
register and we have to get it from somewhere else (for now from some
L2 cache controller register but in the future it may be hardcoded,
passed via FDT or simply trying to boot maxcpus).

-- 
Catalin
