Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0IRPJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:09:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57299 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751014Ab0IRPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:09:45 -0400
Date: Sat, 18 Sep 2010 11:09:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthias Dahl <ml_kernel@mortal-soul.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sched: Improve latencies under load by decreasing
	minimum
Message-ID: <20100918150943.GA2562@Krystal>
References: <201009162048.50941.ml_kernel@mortal-soul.de> <20100918145301.GA19879@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918145301.GA19879@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:09:18 up 238 days, 17:46,  4 users,  load average: 0.01, 0.03,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Matthias Dahl (ml_kernel@mortal-soul.de) wrote:
> > Hi.
> > 
> > I don't know if this is relevant but I just tried this ontop 2.6.35.4 while
> > investigating a different problem and it was quite easy to produce audio
> > buffer underruns while doing some compile job in the background.
> > 
> > To be exact: I had vlc (1.1 git) play back several flac files and was compiling
> > qt 4.7 in the background as a test w/ -j5 on an i7 860 . The result was that w/
> > the decreased granularity it caused noticeable audio buffer underruns while it
> > worked just fine w/ the default granularity (nothing else touched).
> > 
> > Just wanted to report this early on and hope it helps.
> 
> Hi Matthias,
> 
> Thanks for reporting this. I have a few more questions:
> 
> Can you provide:
> 
> you full kernel .config
> 
> The config values of your sound card:
> 
> cat /proc/asound/card0/pcm0p/sub0/hw_params
> cat /proc/asound/card0/pcm0c/sub0/hw_params
> 
> while you play your audio. (could be other than pcm0p, try to get one which is
> not "Closed" while you play) Also providing the dmesg output showing which sound
> card driver you are using might help.
> 
> Also the output of:
> cat /proc/cpuinfo
> 
> Also, can you try reproducing the problem with different players ? With
> non-git-bleeding-edge vlc versions too ? Can you reproduce this problem while
> using "aplay" (a much simpler player) to play wav files ? (I've got an
> instrumented version hooked on my tracer that traces underruns in here).

Also, do you use pulseaudio, alsa directly, or go through OSS ?

Mathieu

> 
> Thanks !
> 
> Mathieu
> 
> > 
> > So long,
> > matthias.
> > 
> > PS. Please cc' as I am not subscribed. Thanks a lot.
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
