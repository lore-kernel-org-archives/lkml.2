Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2FLRKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:10:00 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:59133 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab2FLRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:09:59 -0400
Date: Tue, 12 Jun 2012 10:09:52 -0700
From: Mike Turquette <mturquette@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120612170952.GE19410@gmail.com>
References: <1337004985-22549-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337004985-22549-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120514-15:16, Mark Brown wrote:
> The WM831x and WM832x series of PMICs contain a flexible clocking
> subsystem intended to provide always on and system core clocks.  It
> features:
> 
> - A 32.768kHz crystal oscillator which can optionally be used to pass
>   through an externally generated clock.
> - A FLL which can be clocked from either the 32.768kHz oscillator or
>   the CLKIN pin.
> - A CLKOUT pin which can bring out either the oscillator or the FLL
>   output.
> - The 32.768kHz clock can also optionally be brought out on the GPIO
>   pins of the device.
> 
> This driver fully supports the 32.768kHz oscillator and CLKOUT.  The FLL
> is supported only in AUTO mode, the full flexibility of the FLL cannot
> currently be used.
> 
> Due to a lack of access to systems where the core SoC has been converted
> to use the generic clock API this driver has been compile tested only.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi Mark,

I've taken this into my new clk-next branch which is now based on top of
v3.5-rc2.  I'll send a request to Stephen Rothwell in the coming days so
that clk-next starts getting tested.

Just so we're clear, it is likely that in the current state of things
your clk_prepare calls could deadlock on a production system.  This is a
shortcoming I'm trying to address in the framework, and I don't see it
as a reason to prevent merging your patch, but I didn't want you to be
surprised if you tested this code on a platform ported to common clk.

Regards,
Mike
