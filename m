Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1DAMpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:45:17 -0400
Received: from snt0-omc1-s3.snt0.hotmail.com ([65.55.90.14]:8941 "EHLO
	snt0-omc1-s3.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab1DAMpP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:45:15 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 08:45:15 EDT
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS223A836C90F9E0C2A8AB07A7BE0@phx.gbl>
From: limp <johnkyr83@hotmail.com>
To: "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'Dario Faggioli'" <raistlin@linux.it>
CC: <linux-kernel@vger.kernel.org>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>	 <20110331151214.GB14441@home.goodmis.org> <1301645110.4331.17.camel@Palantir>
In-Reply-To: <1301645110.4331.17.camel@Palantir>
Subject: RE: Minimum time slice for relaible Linux execution
Date: Fri, 1 Apr 2011 13:39:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcvwQ5ctDKbM0Tt3TxqxovsFwnz/PwAJHcTw
Content-Language: en-gb
X-OriginalArrivalTime: 01 Apr 2011 12:39:05.0815 (UTC) FILETIME=[C9CE1670:01CBF069]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you guys for your responses,

To be honest I haven’t looked in detail how RTAI and Xenomai does it but
AFAIK, they don't give a fixed time slice to Linux either (i.e. they switch
To Linux only when they have finished with their RT tasks).

A difference between their implementation and mine is that I don't acknowledge
any Linux interrupt while the RT domain is executed so maybe, if Linux code
is not smart enough to re-issue a lost interrupt, and if the RT domain takes most
of CPU time starving Linux, this can cause Linux to crash at some point. 

The idea of not acknowledging Linux interrupts on RT domain is that I don't
want to add *random* overhead into RT tasks execution.

What do you guys thing?

Kind regards,

John K.


-----Original Message-----
From: Dario Faggioli [mailto:raistlin@linux.it] 
Sent: Friday, April 01, 2011 9:05 AM
To: Steven Rostedt
Cc: limp; linux-kernel@vger.kernel.org
Subject: Re: Minimum time slice for relaible Linux execution

On Thu, 2011-03-31 at 11:12 -0400, Steven Rostedt wrote: 
> On Thu, Mar 31, 2011 at 01:13:55PM +0100, limp wrote:
> > Dear all,
> > 
> > I have developed a framework similar to a hypervisor that switches 
> > between Linux and a RT domain.
> > As RT priority is of highest importance, I want to give more time to 
> > the RT domain *but* I also want to give Linux adequate time for 
> > being able to operate.
> > 
> I'm not sure there is any requirement. The only problem I guess that 
> can happen is if you give such little time that the timer interrupt 
> can't finish, or that every time you schedule Linux back in, the timer 
> interrupt goes off and nothing else gets done.
> 
Right. Moreover, what you're doing seems very very similar to what these guys do: https://www.rtai.org/ , http://www.xenomai.org/ .

I've never checked if (and if yes how) they do such thing as you're thinking, but maybe they do... Have you already looked at them?

Regards,
Dario

--
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

