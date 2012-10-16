Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2JPR3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:29:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:6534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2JPR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:29:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="228142301"
Date: Tue, 16 Oct 2012 10:29:30 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: USB keyboard backlight powering down.
Message-ID: <20121016172930.GF5378@xanatos>
References: <20121016152023.GA25506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016152023.GA25506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:20:23AM -0400, Dave Jones wrote:
> Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
> Logitech USB keyboard doesn't light up until he hits a key, and then
> it immediately powers back off, defeating the purpose of having an
> illumated keyboard.

Does he have the udev bug that turns on auto-suspend for USB keyboards?
ISTR there was a Fedora bug that was fixed.

I ask because it sounds like the keyboard is suspended between key
strokes, and that powers down the light.  The USB hid driver doesn't
auto-suspend devices that have user toggleable LEDs.  For instance, it
won't suspend a keyboard if the caps lock or num lock key is set.  But
I'm betting the device doesn't advertise the backlight like the caps
lock key is advertised.

> Looking over the 3.6.1 changelog, I see this change, which sounds
> like it might be responsible ?

Did he actually do a git bisect?  Because that commit only applies to
when the system is suspended, not when the USB device is suspended.

Sarah Sharp

> commit ee537508bdc0c00b96ac497f3d82a68f820e6182
> Author: Michael Spang <spang@chromium.org>
> Date:   Fri Sep 14 13:05:49 2012 -0400
> 
>     Increase XHCI suspend timeout to 16ms
>     
>     commit a6e097dfdfd189b6929af6efa1d289af61858386 upstream.
>     
>     The Intel XHCI specification says that after clearing the run/stop bit
>     the controller may take up to 16ms to halt. We've seen a device take
>     14ms, which with the current timeout of 10ms causes the kernel to
>     abort the suspend. Increasing the timeout to the recommended value
>     fixes the problem.
>     
>     This patch should be backported to kernels as old as 2.6.37, that
>     contain the commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI:
>     PCI power management implementation".
>     
>     Signed-off-by: Michael Spang <spang@chromium.org>
>     Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> Any thoughts on how we could prevent this generically, or is this
> something we're going to have to quirk around for specific devices we
> don't want to power down ?
> 
> 	Dave
> 
