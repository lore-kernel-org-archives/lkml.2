Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1DANcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:32:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1DANcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:32:08 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=4ay608aMGH4A:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-N8UvQ2GvdtjTz83sZ8A:9 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: RE: Minimum time slice for relaible Linux execution
From: Steven Rostedt <rostedt@goodmis.org>
To: limp <johnkyr83@hotmail.com>
Cc: "'Dario Faggioli'" <raistlin@linux.it>, linux-kernel@vger.kernel.org
In-Reply-To: <SNT111-DS223A836C90F9E0C2A8AB07A7BE0@phx.gbl>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
	 <20110331151214.GB14441@home.goodmis.org>
	 <1301645110.4331.17.camel@Palantir>
	 <SNT111-DS223A836C90F9E0C2A8AB07A7BE0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 09:32:04 -0400
Message-ID: <1301664724.2160.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 13:39 +0100, limp wrote:
> Thank you guys for your responses,
> 
> To be honest I haven’t looked in detail how RTAI and Xenomai does it but
> AFAIK, they don't give a fixed time slice to Linux either (i.e. they switch
> To Linux only when they have finished with their RT tasks).

Perhaps you should look into more detail, maybe they do more than you
expect. Honestly, I haven't looked into detail of what they do either,
so I can not comment on how they work.

> 
> A difference between their implementation and mine is that I don't acknowledge
> any Linux interrupt while the RT domain is executed so maybe, if Linux code
> is not smart enough to re-issue a lost interrupt, and if the RT domain takes most
> of CPU time starving Linux, this can cause Linux to crash at some point. 

What exactly do you mean by not acknowledging Linux interrupts? If an
interrupt takes place while an RT domain is running, you simply drop it?
Yes that will break things. How will Linux know to reissue an interrupt
for a network packet coming in if it never knew it happened?

If your microkernel stores off the interrupt and reissues it to Linux
when Linux gets a chance to run again, then everything would work.
That's pretty much what the virtualization code does.

> 
> The idea of not acknowledging Linux interrupts on RT domain is that I don't
> want to add *random* overhead into RT tasks execution.

Or do you simply mask the interrupts that the RT domain does not care
about when the RT domain runs? This should work as when you unmask them
they should trigger, and then you can pass it to the Linux irq handlers.

-- Steve


