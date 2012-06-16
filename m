Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2FPSFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 14:05:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2FPSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 14:05:43 -0400
Date: Sat, 16 Jun 2012 20:05:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kasza =?iso-8859-1?Q?P=E9ter?= <mr.schyte@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: gregkh@linuxfoundation.org
Subject: Re: Deadlock in suspend console switch
Message-ID: <20120616180526.GB29917@elf.ucw.cz>
References: <20120616093737.GA6914@cirque.teteny.elte.hu>
 <20120616153624.GA9401@cirque.teteny.elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120616153624.GA9401@cirque.teteny.elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

[Rafael really should have been notified].

								Pavel

On Sat 2012-06-16 17:36:24, Kasza Péter wrote:
> Dear Recipients!
> 
> I've found a deadlock bug in the suspend code. If the virtual terminal
> is locked using the VT_PROCESS method (using perhaps vlock[1]), the
> kernel cannot switch to the suspend console, so it waits indefinately
> for the change to occur.
> 
> The console change is initated from "pm_prepare_console"
> (power/console.c), and the "vt_move_to_console" (tty/vt/vt_ioctl) call
> hangs by calling the vt_waitactive function. (This problem obviously
> doesn't occur if the disable_vt_switch variable is true)
> 
> I haven't written a patch, because I'm not sure about the semantics we
> should follow.
> 
> Should the kernel perform the switch to the suspend console even if the
> terminal is locked? Or should we block and notify the clients waiting
> that the switch cannot be completed (the kernel currently just ignores
> the request in this case)?
> 
> The first option is easier to implement, because we don't have to notify
> the clients about the error. However the second option is more
> favourable, because userspace programs can fall into the trap, creating
> a race condition between the switch and the call to the
> VT_WAITACTIVE ioctl.
> 
> In my opinion the suspend vt-switch should always succeed, and the
> clients waiting on the switch should also be notified somehow. But this
> requires some modification of the event handling code, and I haven't
> found an elegant way to do that yet.
> 
> [1] http://freecode.com/projects/vlock
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
