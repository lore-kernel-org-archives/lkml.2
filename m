Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2DSNSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:18:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:39273 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2DSNSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:18:49 -0400
Date: Thu, 19 Apr 2012 15:18:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
In-Reply-To: <4F900DD6.50105@redhat.com>
Message-ID: <alpine.LFD.2.02.1204191516200.2542@ionos>
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com>
 <4F8F59E2.4080301@linaro.org> <alpine.LFD.2.02.1204191437560.2542@ionos> <alpine.LFD.2.02.1204191451350.2542@ionos> <4F900DD6.50105@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Prarit Bhargava wrote:
> On 04/19/2012 08:52 AM, Thomas Gleixner wrote:
> > On Thu, 19 Apr 2012, Thomas Gleixner wrote:
> > 
> >> On Wed, 18 Apr 2012, John Stultz wrote:
> >>> On 04/18/2012 04:59 PM, Prarit Bhargava wrote:
> >>>>
> 
> >> No. The show_state() part prints into the buffer. But it's not
> >> guaranteed that the buffer is flushed right away. It could be flushed
> >> later as well in a different context. And of course the flush code
> >> runs with interrupts disabled and dumping out a gazillion of lines
> >> over serial will cause the same hickup. Just planting random
> >> touch_watchdog() calls into the code is not the right approach,
> >> really.
> >>
> >> We should think about the reasons why we have interrupts disabled for
> >> so much time. Is that really, really necessary ?
> 
> In the case of the sysrq-t, I would argue that it is.  The whole point behind
> the sysrq-t is that we're capturing the *current* state of the system.  Having
> that output effected by interrupts seems like a bad idea.

Nonsense. The system state can change, while we are dumping it unless
you run on an UP system. irq disable only affects the current CPU
nothing else, and nothing can prevent the other cpus to wake up, run,
exit, fork .....

Thanks,

	tglx


