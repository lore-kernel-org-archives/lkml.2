Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2EEKDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:03:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62350 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2EEKDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:03:16 -0400
Date: Sat, 5 May 2012 12:02:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap
 second
Message-ID: <20120505100259.GA8294@netboy.at.omicron.at>
References: <cover.1335442155.git.richardcochran@gmail.com>
 <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
 <4F9B1C55.50004@linaro.org>
 <20120428061718.GA2258@netboy.at.omicron.at>
 <4F9EEC86.8010201@linaro.org>
 <20120501061605.GC2243@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501061605.GC2243@netboy.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 08:16:05AM +0200, Richard Cochran wrote:
> On Mon, Apr 30, 2012 at 12:48:22PM -0700, John Stultz wrote:
> > On 04/27/2012 11:17 PM, Richard Cochran wrote:
> > >
> > >Wait a minute. If user space manages this variable, then shouldn't the
> > >kernel leave it alone?
> > 
> > Right. That's why I'm asking. I actually haven't spent much time
> > looking at how the tai value provided via adjtimex is handled, and I
> > want to make sure its ok if we modify it from the kernel.
> 
> We *are* already modifying it in kernel, but at the wrong time.
> 
> I don't know either what ntpd does, but I will find out.
> 
> [ But if ntpd just uses adjtimex() to use the kernel as storage for
>   variables, then that is really stupid. ]

I took a look at ntp-4.2.6p5, and ntpd unconditionally sets the TAI
offset using MOD_TAI when it thinks the offset has changed.

But I think it won't hurt if the kernel changes the offset
automatically, since ntpd will just try and set the same value again.

Thanks,
Richard
