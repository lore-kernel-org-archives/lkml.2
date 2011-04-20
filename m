Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1DTTQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:16:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58193 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1DTTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:16:20 -0400
Subject: Re: x86: tsc: make TSC calibration more immune to interrupts
From: john stultz <johnstul@us.ibm.com>
To: Kasper Pedersen <kernel@kasperkp.dk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <4DAF2B57.6010100@kasperkp.dk>
References: <4DAF2B57.6010100@kasperkp.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 12:15:59 -0700
Message-ID: <1303326959.2796.136.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 20:52 +0200, Kasper Pedersen wrote:
> When a SMI or plain interrupt occurs during the delayed part
> of TSC calibration, and the SMI/irq handler is good and fast
> so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
> off (10-30ppm).
> 
> We should not depend on interrupts being longer than 50000
> clocks, so always do the 5 tries, and use the best sample we
> get.
> This should work always for any four periodic or rate-limited
> interrupt sources. If we get 5 interrupts with 500ns gaps in
> a row, behaviour should be as without this patch.
> 
> This costs us 20-100 microseconds in startup time, as
> tsc_read_refs is called 8 times.
> 
> measurements:
> On a 700MHz P3 I see t2-t1=~22000, and 31ppm error.
> A Core2 is similar: http://n1.taur.dk/tscdeviat.png
> (while mostly t2-t1=~1000, in about 1 of 3000 tests
> I see t2-t1=~20000 for both machines.)
> vmware ESX4 has t2-t1=~8000 and up.


I guess I'm curious how useful this is with the refined TSC calibration
that was added not too long ago:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=08ec0c58fb8a05d3191d5cb6f5d6f81adb419798

Are you saying that you see the same 10-30ppm variance in the dmesg
line: "Refined TSC clocksource calibration: XXXX.XXX MHz" ?

thanks
-john


