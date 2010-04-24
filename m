Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0DXF5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 01:57:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52464 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862Ab0DXF5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 01:57:05 -0400
Date: Sat, 24 Apr 2010 07:56:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
Message-ID: <20100424055652.GD2290@elf.ucw.cz>
References: <4BCFC3D0.5080904@codeaurora.org>
 <4BD0D9E5.3020606@codeaurora.org>
 <20100423184042.GA16190@Krystal>
 <4BD25C37.4070005@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD25C37.4070005@codeaurora.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Seems a bit more complicated than what I had in mind. This is
> touching the scheduler I think we can get away without having to.
> Also, there is no simple implementation for the "slowpath" that can
> guarantee the delay without starting over the loop and hoping not to
> get interrupted or just giving up and doing a massively inaccurate
> delay (like msleep, etc).
> 
> I was thinking of something along the lines of this:
> 
> udelay()
> {
>   if (!is_atomic())
> 	down_read(&freq_sem);
>   /* else
> 	do nothing since cpufreq can't interrupt you.
>   */
> 
>   call usual code since cpufreq is not going to preempt you.
> 
>   if (!is_atomic())
> 	up_read(&freq_sem);
> }

Well, most delays are very short, so...

What about... we decide that cpufreq interruption or switch to
different cpu takes 100usec minimum, and only try to do complex magic
for delays >100usec? Hopefully there's minimum of those :-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
