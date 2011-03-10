Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1CJWsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:48:50 -0500
Received: from blu0-omc1-s27.blu0.hotmail.com ([65.55.116.38]:16941 "EHLO
	blu0-omc1-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab1CJWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:48:48 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP717C72ABCA411607037A9796C80@phx.gbl>
Date: Thu, 10 Mar 2011 17:48:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <1299780241.15854.393.camel@gandalf.stny.rr.com> <20110310182000.GB2906@redhat.com> <1299782143.15854.402.camel@gandalf.stny.rr.com> <4D791CAA.7090108@caviumnetworks.com> <1299783236.15854.405.camel@gandalf.stny.rr.com> <4D791F31.6040100@caviumnetworks.com> <1299785143.15854.407.camel@gandalf.stny.rr.com> <1299786329.15854.409.camel@gandalf.stny.rr.com> <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl> <1299793339.15854.430.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1299793339.15854.430.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:47:41 up 337 days,  8:37,  5 users,  load average: 0.13, 0.14,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 22:48:47.0678 (UTC) FILETIME=[5134E5E0:01CBDF75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2011-03-10 at 16:22 -0500, Mathieu Desnoyers wrote:
> 
> > > Anyway, I think the best thing for now is to have Jason add
> > > the .align(sizeof(long)) in the inline assembly for all locations and be
> > > done with it.
> > 
> > You seem to be contradicting yourself here. I'm concerned about having
> > "structures" of a size not power of two. Can we simply either
> 
> But we don't have structures. We have data that has been allocated in
> assembly. Come to think of it, it may be best to keep these as 
> ".align 4".

The .align 4 is certainly not the right answer, because it will trigger
unaligned accesses on some 64-bit architectures, as we have faced with
trace event.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
