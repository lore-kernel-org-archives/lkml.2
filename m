Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2D1GRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:17:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32948 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2D1GR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:17:29 -0400
Date: Sat, 28 Apr 2012 08:17:18 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] ntp: advertise correct TAI offset during leap
 second
Message-ID: <20120428061718.GA2258@netboy.at.omicron.at>
References: <cover.1335442155.git.richardcochran@gmail.com>
 <7af92d6eabef55ddce07007ea515eda2e1474c52.1335442155.git.richardcochran@gmail.com>
 <4F9B1C55.50004@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B1C55.50004@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 03:23:17PM -0700, John Stultz wrote:
> On 04/26/2012 05:11 AM, Richard Cochran wrote:
> >When repeating a UTC time value during a leap second (when the UTC
> >time should be 23:59:60), the TAI timescale should not stop. The kernel
> >NTP code increments the TAI offset one second too late. This patch fixes
> >the issue by incrementing the offset during the leap second itself.
> >
> >Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> 
> This looks good to me. Although, have you actually tested against an
> ntp client that sets the tai offset to make sure you're not
> duplicating any ADJ_TAI adjustment it might make?

No, I cooked up my own test program that uses the adjtimex interface
directly. I really am not very familiar with the ntp.org software.

Wait a minute. If user space manages this variable, then shouldn't the
kernel leave it alone?

This David Mills paper [1] gives a leap second example that does it
the "other" way from Linux (see Figure 4), repeating the new epoch
rather than the leap second. It may well be that ntp.org servers do
behave that way. However, the NIST file claims that this way is
unusual.

So, you have a good question. But, if ntp.org uses the NIST second
method, shouldn't Linux do the same?

Thanks,
Richard

1. http://www.eecis.udel.edu/~mills/database/papers/time.pdf
