Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab0E0Rmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:42:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41611 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932921Ab0E0Rmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:42:50 -0400
Date: Thu, 27 May 2010 18:49:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527184918.3d090921@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527172343.GB2468@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527165931.GB1062@srcf.ucam.org>
	<alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<20100527172343.GB2468@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is a "Correctly implemented driver" in this case? One that receives 
> a wakeup event and then prevents suspend being entered until userspace 
> has acknowledged that event? Because that's what an in-kernel suspend 
> blocker is.

Kernel side maybe - but even then its a subset of expressing
latency/lowest level requirements. That bit isn't really too contentious.
You need a kernel object to hang a constraint off.

> ACPI provides no guarantees about what level of hardware functionality 
> remains during S3. You don't have any useful ability to determine which 
> events will generate wakeups. And from a purely practical point of view, 
> since the latency is in the range of seconds, you'll never have a low 
> enough wakeup rate to hit it.

So PCs with current ACPI don't get opportunistic suspend capability. It
probably won't be supported on the Commodore Amiga either - your point ?

> Suspend blockers are the mechanism for the 
> driver to indicate whether the wakeup event has been handled. That's 
> what they're there for. The in-kernel ones don't paper over anything.

Semantically the in kernel blockers and the in kernel expression of
device driven constraints are the same thing except that instead of 
yes/no you replace the boolean with information.


So we go from

	block_suspend() / unblock_suspend()

to
	add_pm_constraint(latency, level) 
	remove_pm_constraint(latency, level);


And if Android choses to interpret that in its policy code as

	if (latency > MAGIC)
		suspend_is_cool();
	else
		suspend_isnt_cool();

that's now isolated in droidspace policy

Alan


