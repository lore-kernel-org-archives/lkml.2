Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1BASrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:47:45 -0500
Received: from www.tglx.de ([62.245.132.106]:45444 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1BASro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:47:44 -0500
Date: Tue, 1 Feb 2011 19:47:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/2] hrtimers: extend hrtimer base code to handle more
 then 2 clockids
In-Reply-To: <1296585448.3336.16.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1102011943090.31804@localhost6.localdomain6>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>  <1296531837-12879-2-git-send-email-john.stultz@linaro.org>  <alpine.LFD.2.00.1102011505540.31804@localhost6.localdomain6> <1296585448.3336.16.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, John Stultz wrote:
> On Tue, 2011-02-01 at 15:10 +0100, Thomas Gleixner wrote:
> > On Mon, 31 Jan 2011, John Stultz wrote:
> > > +static inline int hrtimer_clockid_to_base(clockid_t clock_id)
> > > +{
> > > +	int ret = hrtimer_clock_to_base_table[clock_id];
> > > +
> > > +	if(ret == -1) {
> > > +		WARN_ON(1);
> > > +		/* We just hit an invalid clock base,
> > > +		 * but returning -1 isn't safe, so
> > > +		 * return the _REALTIME base
> > > +		 */
> > 
> >   How can this happen ?
> 
> It can't right now. I'm just worried someone will try to put a clockid
> that doesn't have an hrtimer base into that function sometime in the
> future. We can wrap it in a debug config maybe?

Hmm. That would have exploded the current code as well. So I won't
worry too much about.

Thanks,

	tglx
