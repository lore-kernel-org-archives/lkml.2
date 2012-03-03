Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2CCFyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 00:54:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51929 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2CCFyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 00:54:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of richardcochran@gmail.com designates 10.14.181.193 as permitted sender) smtp.mail=richardcochran@gmail.com; dkim=pass header.i=richardcochran@gmail.com
Date: Sat, 3 Mar 2012 06:54:12 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/9] time: Condense timekeeper.xtime into xtime_sec
Message-ID: <20120303055411.GA3835@netboy.at.omicron.at>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
 <1330672368-32290-2-git-send-email-john.stultz@linaro.org>
 <alpine.DEB.2.00.1203021510540.20257@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203021510540.20257@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:13:25PM -0600, Christoph Lameter wrote:
> On Thu, 1 Mar 2012, John Stultz wrote:
> 
> > +static inline void tk_normalize_xtime(struct timekeeper *tk)
> > +{
> > +	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
> > +		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
> > +		tk->xtime_sec++;
> > +	}
> > +}
> 
> Could we avoid the loop?
> 
> y = ((u64)NSEC_PER_SEC << tk->shift));
> tk->xtime_sec += tk->xtime_nsec / y;
> tk->xtime_nsec %= y;

But the two divisions are more costly than addition, substraction, and
shift.

(Normally the code loops just once.)

Richard
