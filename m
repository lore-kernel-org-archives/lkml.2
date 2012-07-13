Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2GMGKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:10:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45467 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2GMGKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:10:51 -0400
Date: Fri, 13 Jul 2012 08:03:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 6/8] time: Move arch_gettimeoffset() usage into
 timekeeping_get_ns()
Message-ID: <20120713060301.GE18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-7-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-7-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> +	nsec >>= timekeeper.shift;
> +
> +	/* If arch requires, add in gettimeoffset() */
> +	nsec += arch_gettimeoffset();
> +	return nsec;

As a factoring out bonus, this could be further shortened to:

	return nsec + arch_gettimeoffset();

> +	/* If arch requires, add in gettimeoffset() */
> +	nsec += arch_gettimeoffset();
> +	return nsec;

Ditto.

Thanks,

	Ingo
