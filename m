Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0EFQkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:40:17 -0400
Received: from bamako.nerim.net ([62.4.17.28]:53742 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0EFQkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:40:15 -0400
Date: Thu, 6 May 2010 18:40:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: lm-sensors@lm-sensors.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Simple fan question
Message-ID: <20100506184011.2a2cfec9@hyperion.delvare>
In-Reply-To: <1272581806.24542.185.camel@pasglop>
References: <1272518506.24542.163.camel@pasglop>
	<20100429105740.6e3b7716@hyperion.delvare>
	<1272581806.24542.185.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Sorry for the delay.

On Fri, 30 Apr 2010 08:56:46 +1000, Benjamin Herrenschmidt wrote:
> > For RPM-controlled, look at the following entry instead:
> > 
> > fan[1-*]_target
> > 		Desired fan speed
> > 		Unit: revolution/min (RPM)
> > 		RW
> > 		Only makes sense if the chip supports closed-loop fan speed
> > 		control based on the measured fan speed.
> > 
> > One significant difference is that, in this case, you always know which
> > fan you control, while in the pwm[1-*] case you don't.
> 
> Right.
> 
> Now, maybe the best option is to have instead:
> 
> 	fan[1-*]_discrete_value
> 		Discrete value
>                 RW
> 
> 	fan[1-*]_supported values
>                 List of supported discrete values
>                 RO
> 
> IE. I like the interface to be self-explanatory rather than relying on
> the user to know in advance what to write there. In which case I could
> either use 0,1,2 as values or even "off, slow, fast".

I have no objection.

> I can then make a custom fancontrol script (or add a wart to the
> existing one) to deal with this HW.
> 
> What do you think ?

Please don't try to add this to the fancontrol script. It's messy
enough as is ;) You probably want to implement the kernel part and the
user-space part together before you propose a standard interface,
otherwise it might be difficult to make the best decisions with regards
to attribute names and values.

> Another option of course is to do the whole thermal control in a kernel
> thread :-) That wouldn't be very hard nor take a lot of code, but I'm
> sure I'll encounter resistance trying to merge that :-)

Me, I wouldn't object. That's what you did for other systems as far as I
can see? As long as things work in the end, I have no problem with
fan speed control being in the kernel. Having it in user-space has its
share of issues (e.g. risk of overheating is the script dies for any
reason.)

But yes, others may complain.

-- 
Jean Delvare
