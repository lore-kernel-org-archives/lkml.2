Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1BBI3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:29:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44919 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1BBI3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:29:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vC96jI7kZtUUlDCNTdZvy6UFwD2Y8ZIIi2R3adjo/Aptqk9w9gVYL82VVFf5iEsA/6
         1yEHY65Sx+e4LyAckzQES0v5mkYvP9UUYvKj9Wljb9+JGjvQ85DWWFLRJWhFOWG0EB/I
         D11xDPjWrRZU9s/3FvM1m3+NHCULASl8sKf8s=
Date: Wed, 2 Feb 2011 09:29:43 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 18/28] posix-timers: Convert timer_delete() to
 clockid_to_kclock()
Message-ID: <20110202082943.GC2747@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134419.198999420@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134419.198999420@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:52:07PM -0000, Thomas Gleixner wrote:
> Index: linux-2.6-tip/kernel/posix-timers.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/posix-timers.c
> +++ linux-2.6-tip/kernel/posix-timers.c
> @@ -254,6 +254,7 @@ static __init int init_posix_timers(void
>  		.timer_create	= common_timer_create,
>  		.timer_set	= common_timer_set,
>  		.timer_get	= common_timer_get,
> +		.timer_del	= common_timer_del,
>  	};
>  	struct k_clock clock_monotonic = {
>  		.clock_getres	= hrtimer_get_res,
> @@ -263,6 +264,7 @@ static __init int init_posix_timers(void
>  		.timer_create	= common_timer_create,
>  		.timer_set	= common_timer_set,
>  		.timer_get	= common_timer_get,
> +		.timer_del	= common_timer_del,
>  	};
>  	struct k_clock clock_monotonic_raw = {
>  		.clock_getres	= hrtimer_get_res,

The definition of common_timer_del() should not be "inline" since the
address of the function is in these tables. The declaration is not
inline, and gcc 4.2.4 gives a warning.

(But strangly, newer versions do not).

Thanks,
Richard
