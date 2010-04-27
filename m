Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0D0Plp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:41:45 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50201 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754033Ab0D0Plm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:41:42 -0400
Date: Tue, 27 Apr 2010 08:41:34 -0700
From: Philip Langdale <philipl@overt.org>
To: Len Brown <lenb@kernel.org>
Cc: Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100427084134.2874d142@fido5>
In-Reply-To: <alpine.LFD.2.00.1004270319560.3999@localhost.localdomain>
References: <20100126084740.GA5265@jgarrett.org>
	<87y6jkee1b.fsf@basil.nowhere.org>
	<20100205160900.GA2736@jgarrett.org>
	<alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
	<20100426194002.586fbaa5@fido5>
	<alpine.LFD.2.00.1004270319560.3999@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 03:26:34 -0400 (EDT)
Len Brown <lenb@kernel.org> wrote:

> 
> 
> Curious failure.
> I could imagine that there is something in the design of this board
> where we want to not enter a deep C-state, and thus the board and
> Linux are doing the right thing by avoiding the C-state.
> However, ignoring the bm-status check and blindly going to that state
> I would expect to impact throughput and latency, but don't see
> how that might 'serialize' the workload or otherwise cause it
> to use some cores and not others.

Hmm - and now I can't reproduce it. I got proper parallelization across
the kernel compile. I guess some sort of runtime state was messed up,
and I obviously lost that then I rebooted. :-/
 
> It is possible that we jump into those deep states just to be
> immediately forced to jump right back out.  You'd see this in
> high usage counts under /sys/devices/system/cpu/cpu*/cpuidle
> 
> turbostat, of course, would tell you the actual residency in those
> states. Of course there is a twist...  The hardware has a feature to
> recognize thrashing and may demote an OS request for a deep state into
> an actual hardware request for a shallower state.  this is one reason
> that the output of powertop (request) and turbostat (result)
> may be different.

Without the patch, Turbostat showed C3 residency of 99% for most
hyper-threads with one or two getting ~15% C6 residency. PC3 was 75%.
Cores were at their lowest P state.

With the patch, C6 residency is 99%, PC6 is 75% and 7 hyper-threads at
lowest P state with one stubborning running at a higher level.

I have a very similarly configured machine with an asus motherboard and
it doesn't have this problem - which is another reason I'm wondering if
it's an OEM screwup.

--phil
