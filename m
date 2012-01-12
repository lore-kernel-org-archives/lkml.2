Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab2ALQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:58:16 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:63734 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754317Ab2ALQ6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:58:12 -0500
thread-index: AczRS11Oa7BHssoiS/+K8con9ya1ig==
Thread-Topic: [ANNOUNCE] 3.0.14-rt31
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
Date: Thu, 12 Jan 2012 17:57:25 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Clark Williams" <williams@redhat.com>,
        "John Kacur" <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201121118.34776.tim.sander@hbm.com> <1326376484.7642.65.camel@gandalf.stny.rr.com>
In-Reply-To: <1326376484.7642.65.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201121757.25467.tim.sander@hbm.com>
X-OriginalArrivalTime: 12 Jan 2012 16:58:10.0308 (UTC) FILETIME=[5D2FFC40:01CCD14B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

Thanks for your reply.

> > I have just tested 3.0.14 with some local adaptions. Unfortunatly there
> > we have still two errors here:
> > Reboot ( of upstart) fails sometimes fails with the following message:
> > "reboot: Unable to execute shutdown: Bad address"
> 
> What's the bad address? Was there a kernel oops?
Well i traced it down to the error message of reboot from upstart.
(upstart-1.3/util/reboot.c:211). Presumably it was a "bad page" error out of 
the memory from the developer who reported that. Unfortunatly this error does 
not happen to often. I am not aware of a kernel oops.
(My other mail to this list: https://lkml.org/lkml/2011/12/7/657)

> > This problem can probably easily worked around by catching a failed
> > execution and retry, but i am afraid that execution fails more often in
> > other places and leads to silent functionality failures.
> > 
> > and the running wild ksoftirqd0 most probably after the kernel message:
> > "sched: RT throttling activated"
> 
> Hmm, that's not good. It means that an RT task is spinning too much.
Mh, sorry i was to terse on that. This only happens after first boot on UBIFS
update, but it shows that somehow there seems to be a corner case when
throtteling is activated. Since this seems to be the reason for ksoftirq0 
running as much cpu as it gets. I just patched out switch to rt throtteling
and i will ask the mtd guys about the work they presumably do in interrupt
context which causes this throtteling in the first place.

> > It also seems as if the system looks up after running ifconfig. But it
> > seems as if the error only shows up most of the times if i am not
> > around.
> 
> s/looks/locks/ ?
Ups yes. 

> If it happens after ifconfig, then obviously that looks to be something
> to do with either the network driver or the network stack.
Strangely top,dmesg works. We have a second avahi autoip network interface 
(eth0:avahi). Probably there is s.t. in this codepath.
 
> But there's really nothing I can do to look into this without more
> information.
It would be good if i could get some advice how to get useful information out 
of the system to pinpoint these errors (e.g. special sysrequests or s.t. like 
that). For the reboot case i will try to find the exact return value on 
failure, but for the ksoftirq0 case i currently try to work around that 
problem (by patching out the switch to throtteling) but currently i don't see 
a way to tackle the root of this behaviour.

Best regards
Tim

Please ignore:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
