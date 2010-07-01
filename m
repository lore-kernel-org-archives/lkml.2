Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0GAQZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:25:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57326 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0GAQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nfVC2YLkv8g5boml+LnTGgdyGb+dYBN/gecT99tuLL9xz83/sZMZ5NtDyya4SrX5Cg
         WtEUi17tl1npORVxeyedXrfHTFyETsbg7RodQfpuBdlgIsbXgRiuX1j7CGULG9uPyvTG
         02JqcBYtUllh0iOw8FlDY2ysptELagLkIquqQ=
Date: Thu, 1 Jul 2010 09:24:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jerome Lacoste <jerome.lacoste@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100701162454.GD4152@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome,

On Thu, Jul 01, 2010 at 07:00:45AM +0200, Jerome Lacoste wrote:
> [Please CC me]
> 
> Hei,
> 
> I've had a suspend/resume issue for 3 years: my mouse isn't working
> upon resume. I see this at resume time:
> 
>     i8042: failed to resume active multiplexor, mouse won't work.
> 
> and also some
> 
>     atkbd.c: Spurious ACK on isa0060/serio0. Some program might be
> trying access hardware directly.
> 
> I used to solve it by unbinding/binding my i8042 module after suspend.
> Worked great.
> Now that I've upgraded my distribution once more, the latest kernel
> doesn't expose unbind/bind attributes for the driver.
> See http://marc.info/?l=linux-kernel&m=125585230724962&w=2 for patch
> and thread that (understandably) disabled the feature.
> 
> So it looks like there's no workaround left for me to troubleshoot
> this problem. I guess I need to finally fix the original issue !
> 
> I've enabled i8042.debug. I've tested the following: boot. go to
> console. echo mem > /sys/power/state, resume, ALT+F7: no mouse on gdm.
> 

...

> 
> so i8042_set_mux_mode() doesn't seem to work at all
> 
> I am running
> 
>     Linux expresso2 2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3
> 22:02:19 UTC 2010 i686 GNU/Linux
> 
> But as far as I can tell, there's no modification to i8042 in that
> kernel (http://packages.ubuntu.com/en/lucid/linux-image-2.6.32-22-generic)
> 
> Let me know if you need anything else.
> 
> Cheers,
> 
> Jerome
> 
> For reference,
> 
> * the hardware is a Lenovo 3000 N100

We already trying to disable MUX mode on Lenovo 3000 N100, see
drivers/input/serio/i8042-x86ia64io.h:

	{
		/* Lenovo 3000 n100 */
		.matches = {
			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
		},
	},

What's in your dmi?

-- 
Dmitry
