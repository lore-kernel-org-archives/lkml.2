Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2AIWyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:54:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49966 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933412Ab2AIWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:54:21 -0500
Date: Mon, 9 Jan 2012 22:54:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: USB Host port inoperative after kexec on Beagleboard
Message-ID: <20120109225403.GB23090@mudshark.cambridge.arm.com>
References: <w4wr90wmrx.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w4wr90wmrx.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:09:54PM +0000, Peter Chubb wrote:
> 
> Hi Will,

Hi Peter [adding linux-arm-kernel],

>    Thanks for the fixes to kexec for ARM that went into mainline this
>    week.  Mostly things work now.

Great, that's good to hear!

>    One issue: the USB EHCI port on the (rev C2) beagleboard doesn't
>    work after a kexec.  During boot after kexec, the host device is
>    detected and initialised, but nothing plugged in works, even when
>    everything was working corectly before the kexec.  Das U-boot
>    must set up something that is then undone during the kexec reboot.

Ouch. Have you had a chance to look at the u-boot sources to see what it
does?

>    I've traced all calls to clk_enable() and clk_disable(), and
>    everything looks all right --- in particular I can't see 
>    anything explicitly disabled during kexec that isn't reenabled
>    during boot of the subsequent kernel.
> 
>    Voltages that I can measure look correct on the port.
> 
>    Do you have any suggestions as to what else could be wrong?

I'm afraid I'm not familiar with the Beagleboard, so I can't begin to guess.
Have you tried re-initialising the host controller in the new kernel
manually (perhaps my building the driver as a module and {un}loading it a
few times?). It could be that some hardware state persists across the kexec
and it just needs resetting.

Will
