Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab0LTUna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:43:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0LTUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:43:29 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Zf2-li83EnIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=OYio4vF4G4IM_xNO9tcA:9 a=lFPjDUml4yOAq51wSYsA:7 a=xkNxtO8JBmf7DhwUf1Ra2pzJO2QA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Oops in trace_hardirqs_on (powerpc)
From: Steven Rostedt <rostedt@goodmis.org>
To: =?ISO-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20101219132705.GE6615@alea.gnuu.de>
References: <20100806233157.GA7117@alea.gnuu.de>
	 <1285184671.26872.127.camel@gandalf.stny.rr.com>
	 <20100927125037.GA4497@alea.gnuu.de> <1285639094.2989.1.camel@frodo>
	 <20101219132705.GE6615@alea.gnuu.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 15:43:26 -0500
Message-ID: <1292877806.22905.62.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 14:27 +0100, Jörg Sommer wrote:
> Hi Steven,
> 
> Steven Rostedt hat am Mon 27. Sep, 21:58 (-0400) geschrieben:
> > On Mon, 2010-09-27 at 14:50 +0200, Jörg Sommer wrote:
> > > Hello Steven,
> > > 
> > > Steven Rostedt hat am Wed 22. Sep, 15:44 (-0400) geschrieben:
> > > > Sorry for the late reply, but I was on vacation when you sent this, and
> > > > I missed it while going through email.
> > > > 
> > > > Do you still have this issue?
> > > 
> > > No. I've rebuild my kernel without TRACE_IRQFLAGS and the problem
> > > vanished, as expected. The problem is, that in some cases the stack is
> > > only two frames deep, which causes the macro CALLER_ADDR1 makes an
> > > invalid access. Someone told me, there a workaround for the problem on
> > > i386, too.
> > > 
> > > % sed -n 2p arch/x86/lib/thunk_32.S
> > >  * Trampoline to trace irqs off. (otherwise CALLER_ADDR1 might crash)
> > 
> > Yes, I remember that problem. When I get back from Tokyo, I'll tried to
> > remember to fix it.
> 
> Did you've fixed this problem? The bug report is still marked as open.
> https://bugzilla.kernel.org/show_bug.cgi?id=16573
> 

Ah, this email got lost in the hundreds I had when I got back from
Tokyo, sorry about that again :-(

Anyway, it looks like this only affects 32 bit PPC as I can't reproduce
it with my 64 bit one. And also, unfortunately, my 32bit ppc got taken
from me by my kids, so I can't test it on that either.

I'll look to see if I can write up a patch. Perhaps you could test it
for me.

Thanks,

-- Steve


