Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1J1GFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:05:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41136 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1J1GFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:05:37 -0400
Date: Fri, 28 Oct 2011 08:05:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chen Jie <chenj@lemote.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Improve documentation of timekeeeping_adjust()
Message-ID: <20111028060534.GB1957@netboy.at.omicron.at>
References: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 06:12:42PM -0700, John Stultz wrote:
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index a5846a8..de8737e 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -802,14 +802,44 @@ static void timekeeping_adjust(s64 offset)
>  	s64 error, interval = timekeeper.cycle_interval;
>  	int adj;
>  
> +	/*
> +	 * The point of this is to check if the error is greater then half
> +	 * an interval.
> +	 *
> +	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
> +	 *
> +	 * Note we subtract one in the shift, so that error is really error*2.
> +	 * This "saves" dividing(shifting) intererval twice, but keeps the
> +	 * (error > interval) comparision as still measuring if error is
> +	 * larger then half an interval.
> +	 *
> +	 * Note: It does not "save" on aggrivation when reading the code.

... or on "aggravation" either :)

Thanks,
Richard
