Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031408Ab2COAeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:34:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:37928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031361Ab2COAeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:34:20 -0400
Date: Thu, 15 Mar 2012 01:34:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] time: x86: Fix race switching from vsyscall to
 non-vsyscall clock
In-Reply-To: <1331769536-4602-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.02.1203150131390.2466@ionos>
References: <1331769536-4602-1-git-send-email-john.stultz@linaro.org> <1331769536-4602-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, John Stultz wrote:
>  notrace static noinline int do_realtime(struct timespec *ts)
>  {
>  	unsigned long seq, ns;
> +	int mode;

Please keep a newline between declarations and code.

>  	do {
>  		seq = read_seqbegin(&gtod->lock);
> +		mode = gtod->clock.vclock_mode;
>  		ts->tv_sec = gtod->wall_time_sec;
>  		ts->tv_nsec = gtod->wall_time_nsec;
>  		ns = vgetns();
>  	} while (unlikely(read_seqretry(&gtod->lock, seq)));
> +
>  	timespec_add_ns(ts, ns);
> -	return 0;
> +	return mode;
>  }
>  
>  notrace static noinline int do_monotonic(struct timespec *ts)
>  {
>  	unsigned long seq, ns, secs;
> +	int mode;

etc. etc. 

>  	do {
