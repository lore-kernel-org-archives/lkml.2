Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0E0TTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:19:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55382 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754598Ab0E0TTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:19:00 -0400
Date: Thu, 27 May 2010 20:25:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527202538.7d2d7f3c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527185658.GA5703@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<20100527160543.2228fc17@lxorguk.ukuu.org.uk>
	<20100527160714.GB31937@srcf.ucam.org>
	<20100527174131.18fd1c72@lxorguk.ukuu.org.uk>
	<20100527165210.GA1062@srcf.ucam.org>
	<20100527190204.14546caa@lxorguk.ukuu.org.uk>
	<20100527181239.GF3543@srcf.ucam.org>
	<20100527194840.5bca973f@lxorguk.ukuu.org.uk>
	<20100527185658.GA5703@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is determining how to constrain it to go idle, where "idle" 
> is defined as "Doesn't wake up until a wakeup event is received". It's 
> acceptable for something to use as much CPU as it wants when the user is 
> actively interacting with the device, but in most cases processes 
> shouldn't be permitted to use any CPU when the session is idle. The 
> question is how to implement something that allows a CPU-guzzling 
> application to be idled without impairing its ability to process wakeup 
> events.

>From your literal description:

setpriority. signal, process groups.

	kill(-desktopgroup, SIGSTOP);
	kill(-desktopgroup, SIGCONT);
	kill(pid_i_am_crit_eventing, SIGCONT);

or SIGTSTP might be friendlier as a well behaved smart app can catch it,
fire it into the event loop and elegantly save and sleep.

Some window managers played with doing setpriority for focussed windows.
OLPC the same thing for OOM targets via /proc/oom_adj

The scheduler can happily do this, the power management will also
recognize STOPPED processes as no impediment to suspend.




