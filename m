Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3AGThI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:37:08 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:33039 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3AGThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:37:07 -0500
Date: Mon, 7 Jan 2013 20:37:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.8-rc2
In-Reply-To: <alpine.DEB.2.00.1301072030590.18868@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1301072031540.18907@ayla.of.borg>
References: <alpine.DEB.2.00.1301072030590.18868@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.8-rc2 to v3.8-rc1[3], the summaries are:
>   - build errors: +3/-3

3 regressions:
  + drivers/gpio/gpio-sx150x.c: error: field 'gpio_chip' has incomplete type: 47:35 => 47:35, 47:19
  + drivers/mfd/htc-i2cpld.c: error: field 'chip_in' has incomplete type: 55:26 => 55:19, 55:26
  + drivers/mfd/htc-i2cpld.c: error: field 'chip_out' has incomplete type: 51:26 => 51:26, 51:19

I guess these are just new fallout from the two bogus "selects GPIOLIB" in
SSB/BCMA, pulling in all GPIO drivers on platforms that don't support it,
for which I posted two patches a while ago:
    https://lkml.org/lkml/2012/12/16/68
    https://lkml.org/lkml/2012/12/16/69

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
