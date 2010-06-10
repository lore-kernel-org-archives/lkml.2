Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab0FJTxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:53:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43157 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0FJTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:53:28 -0400
Subject: Re: Timekeeping issue on aggressive suspend/resume
From: john stultz <johnstul@us.ibm.com>
To: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <AANLkTin-6XsW49ECufTLcdzaD1eK9bAxe0j7RXvPqN7p@mail.gmail.com>
References: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com>
	 <alpine.LFD.2.00.1006092206020.2933@localhost.localdomain>
	 <AANLkTin-6XsW49ECufTLcdzaD1eK9bAxe0j7RXvPqN7p@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 12:52:48 -0700
Message-ID: <1276199568.16089.35.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 23:34 -0700, Suresh Rajashekara wrote:
> On Wed, Jun 9, 2010 at 1:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Though we could change that conditionally - the default would still be
> > the freeze of jiffies and CLOCK_MONOTONIC for historical compability.
> 
> If I were to change it only for our implementation, and make all the
> user space timers use CLOCK_REALTIME, then could you please point me
> in a direction as to what part of the kernel I should be touching to
> make that change?

I think Thomas was suggesting that you consider creating a option for
where CLOCK_MONOTONIC included total_sleep_time.

In that case the *hack* (and this is a hack, we'll need some more
thoughtful discussion before anything like it could make it upstream)
would be in timekeeping_resume() to comment out the lines that update
wall_to_monotonic and total_sleep_time.

It would be interesting to hear if that hack works for you, and we can
try to come up with a better way to think about how to accommodate both
views of how to account time over suspend.

Thomas, might this call for a new posix clock_id, CLOCK_BOOTTIME (ie:
CLOCK_MONOTONIC + total_sleep_time) or something that userland could use
to set timers on?

thanks
-john


