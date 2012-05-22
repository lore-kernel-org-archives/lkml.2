Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2EVEZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:25:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53205 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2EVEZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:25:45 -0400
Date: Tue, 22 May 2012 06:25:34 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 4/6] time: introduce leap second functional
 interface
Message-ID: <20120522042534.GA2184@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com>
 <4FBA82DF.9060009@linaro.org>
 <20120521191844.GC19812@netboy.at.omicron.at>
 <4FBAA499.1070905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBAA499.1070905@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 01:24:57PM -0700, John Stultz wrote:
> On 05/21/2012 12:18 PM, Richard Cochran wrote:
> Hrm.  I prefer to keep things fairly flat (even having time.h and
> timex.h bugs me somewhat).  But having such a separation could be
> useful, but maybe at a slightly more coarse level. Something like
> timekeeping-internal.h and time.h, splitting all the general
> accessors away from the non-general.

Yes, time.h is full of stuff not really for public use. When compiling
on an atom netbook as I do, it gets really noticeable and annoying
when you tweak some private prototype, and then the whole darn kernel
rebuilds.

> The locking order is pretty straight forward: timekeeper.lock ->
> ntp_lock.   This only gets messy when you require timekeeping data
> from the ntp context, but usually we provide the required data via
> the caller.  But better documentation is always welcome.

The icky part is the fact that ntp would need access to timekeeper
state while holding ntp_lock.

Richard
