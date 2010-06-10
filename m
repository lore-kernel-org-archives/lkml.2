Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0FJGex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:34:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33300 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0FJGew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=F2HqRpelYzDkeBCFXmUD5bJLZhUi8r9ab61c8rVWN0knXTb1ClgcXUPXHUrpoQSNwy
         FyE/DBNfJ2se+0Fz8AQSQ95huqp5nB4i755qUVkXGb5MibMXLJ6fE7kZhhoCY9Zez8qT
         cO6KqcfKA7yh9VJZjMTIvNPKQDuPyZj1OdeQk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006092206020.2933@localhost.localdomain>
References: <AANLkTinIO5a1EeK6Ej2ljkuyL9zv06OMfbyiZBaxTQTd@mail.gmail.com> 
	<alpine.LFD.2.00.1006092206020.2933@localhost.localdomain>
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Wed, 9 Jun 2010 23:34:31 -0700
X-Google-Sender-Auth: QpiV0WornBQzLWjzIEHoqu77EXc
Message-ID: <AANLkTin-6XsW49ECufTLcdzaD1eK9bAxe0j7RXvPqN7p@mail.gmail.com>
Subject: Re: Timekeeping issue on aggressive suspend/resume
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 1:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Though we could change that conditionally - the default would still be
> the freeze of jiffies and CLOCK_MONOTONIC for historical compability.

If I were to change it only for our implementation, and make all the
user space timers use CLOCK_REALTIME, then could you please point me
in a direction as to what part of the kernel I should be touching to
make that change?

Earlier we faced issue with time that the application sees. It wasn't
getting updated when we suspend and resume the system (where as the
time inside the kernel kept updating) and hence eventually would drift
from the actual time.

for eg, if I use this loop at the command prompt

while date
do
echo mem > /sys/power/state
done

then the date command always displayed the same time, but the prints
from the kernel (I was using the printk time information) was
advancing as expected.

I found a patch at
https://patchwork.kernel.org/patch/50070/

Though this fixed the application time update issue, there are lot of
timers in the application which is still not working right.

Could anyone please point in some direction to find the solution?

Thanks,
Suresh
